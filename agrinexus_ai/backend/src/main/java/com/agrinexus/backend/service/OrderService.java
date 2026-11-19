package com.agrinexus.backend.service;

import com.agrinexus.backend.model.dto.OrderDto;
import com.agrinexus.backend.model.dto.OrderRequest;
import com.agrinexus.backend.model.entity.Order;
import com.agrinexus.backend.model.entity.Product;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.model.enums.OrderStatus;
import com.agrinexus.backend.repository.OrderRepository;
import com.agrinexus.backend.repository.ProductRepository;
import com.agrinexus.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    @Transactional
    public OrderDto placeOrder(Long buyerId, OrderRequest req) {
        User buyer = userRepository.findById(buyerId)
                .orElseThrow(() -> new IllegalArgumentException("Buyer not found: " + buyerId));

        Product product = productRepository.findById(req.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + req.getProductId()));

        if (product.getQuantity().compareTo(req.getQuantity()) < 0) {
            throw new IllegalArgumentException("Insufficient quantity available. Current stock: " + product.getQuantity());
        }

        BigDecimal total = product.getUnitPrice().multiply(req.getQuantity());

        // Deduct inventory
        product.setQuantity(product.getQuantity().subtract(req.getQuantity()));
        if (product.getQuantity().compareTo(BigDecimal.ZERO) == 0) {
            product.setStatus("SOLD");
        }
        productRepository.save(product);

        Order order = Order.builder()
                .buyer(buyer)
                .product(product)
                .quantity(req.getQuantity())
                .totalAmount(total)
                .status(OrderStatus.PENDING)
                .notes(req.getNotes())
                .build();

        Order saved = orderRepository.save(order);
        return mapToDto(saved);
    }

    public List<OrderDto> getBuyerOrders(Long buyerId) {
        return orderRepository.findByBuyerIdOrderByCreatedAtDesc(buyerId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    public List<OrderDto> getFarmerOrders(Long farmerId) {
        return orderRepository.findByProductFarmerIdOrderByCreatedAtDesc(farmerId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public OrderDto updateStatus(Long orderId, String newStatus) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + orderId));

        OrderStatus status = OrderStatus.valueOf(newStatus.toUpperCase());
        order.setStatus(status);

        if (status == OrderStatus.DELIVERED) {
            User buyer = order.getBuyer();
            buyer.setCompletedOrders(buyer.getCompletedOrders() + 1);
            userRepository.save(buyer);

            User farmer = order.getProduct().getFarmer();
            farmer.setCompletedOrders(farmer.getCompletedOrders() + 1);
            userRepository.save(farmer);
        }

        return mapToDto(orderRepository.save(order));
    }

    public OrderDto mapToDto(Order o) {
        return OrderDto.builder()
                .id(o.getId())
                .buyerId(o.getBuyer() != null ? o.getBuyer().getId() : null)
                .buyerName(o.getBuyer() != null ? o.getBuyer().getName() : "Unknown")
                .productId(o.getProduct() != null ? o.getProduct().getId() : null)
                .productName(o.getProduct() != null ? o.getProduct().getName() : "Unknown")
                .farmerId(o.getProduct() != null && o.getProduct().getFarmer() != null ? o.getProduct().getFarmer().getId() : null)
                .farmerName(o.getProduct() != null && o.getProduct().getFarmer() != null ? o.getProduct().getFarmer().getName() : "Unknown")
                .quantity(o.getQuantity())
                .unitPrice(o.getProduct() != null ? o.getProduct().getUnitPrice() : BigDecimal.ZERO)
                .totalAmount(o.getTotalAmount())
                .status(o.getStatus().name())
                .notes(o.getNotes())
                .createdAt(o.getCreatedAt())
                .build();
    }
}
