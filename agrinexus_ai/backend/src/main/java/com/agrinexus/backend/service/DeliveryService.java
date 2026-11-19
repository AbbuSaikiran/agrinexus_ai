package com.agrinexus.backend.service;

import com.agrinexus.backend.model.dto.DeliveryDto;
import com.agrinexus.backend.model.entity.Delivery;
import com.agrinexus.backend.model.entity.Order;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.repository.DeliveryRepository;
import com.agrinexus.backend.repository.OrderRepository;
import com.agrinexus.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DeliveryService {

    private final DeliveryRepository deliveryRepository;
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;

    @Transactional
    public DeliveryDto assignDelivery(Long orderId, Long partnerId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + orderId));

        User partner = userRepository.findById(partnerId)
                .orElseThrow(() -> new IllegalArgumentException("Logistics partner not found: " + partnerId));

        Delivery delivery = deliveryRepository.findByOrderId(orderId)
                .orElse(Delivery.builder()
                        .order(order)
                        .partner(partner)
                        .pickupLocation(order.getProduct().getLocation())
                        .dropLocation("Warangal Central Hub")
                        .status("ASSIGNED")
                        .assignedAt(LocalDateTime.now())
                        .build());

        delivery.setPartner(partner);
        delivery.setStatus("ASSIGNED");
        delivery.setAssignedAt(LocalDateTime.now());

        return mapToDto(deliveryRepository.save(delivery));
    }

    @Transactional
    public DeliveryDto updateDeliveryStatus(Long deliveryId, String status) {
        Delivery delivery = deliveryRepository.findById(deliveryId)
                .orElseThrow(() -> new IllegalArgumentException("Delivery not found: " + deliveryId));

        delivery.setStatus(status.toUpperCase());
        if ("DELIVERED".equalsIgnoreCase(status)) {
            delivery.setDeliveredAt(LocalDateTime.now());
        }

        return mapToDto(deliveryRepository.save(delivery));
    }

    public List<DeliveryDto> getPartnerDeliveries(Long partnerId) {
        return deliveryRepository.findByPartnerId(partnerId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    private DeliveryDto mapToDto(Delivery d) {
        return DeliveryDto.builder()
                .id(d.getId())
                .orderId(d.getOrder() != null ? d.getOrder().getId() : null)
                .partnerId(d.getPartner() != null ? d.getPartner().getId() : null)
                .partnerName(d.getPartner() != null ? d.getPartner().getName() : "Unassigned")
                .pickupLocation(d.getPickupLocation())
                .dropLocation(d.getDropLocation())
                .status(d.getStatus())
                .assignedAt(d.getAssignedAt())
                .deliveredAt(d.getDeliveredAt())
                .build();
    }
}
