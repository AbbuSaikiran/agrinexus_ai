package com.agrinexus.backend.service;

import com.agrinexus.backend.model.dto.ProductDto;
import com.agrinexus.backend.model.dto.ProductRequest;
import com.agrinexus.backend.model.entity.Product;
import com.agrinexus.backend.model.entity.User;
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
public class ProductService {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    public List<ProductDto> searchProducts(String query, String category) {
        List<Product> products;
        if (category != null && !category.equalsIgnoreCase("ALL") && !category.isBlank()) {
            products = productRepository.findByCategoryIgnoreCaseAndStatus(category, "AVAILABLE");
        } else {
            products = productRepository.searchAvailable(query);
        }
        return products.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    public ProductDto getProductById(Long id) {
        Product p = productRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + id));
        return mapToDto(p);
    }

    public List<ProductDto> getFarmerProducts(Long farmerId) {
        return productRepository.findByFarmerId(farmerId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public ProductDto createProduct(Long farmerId, ProductRequest req) {
        User farmer = userRepository.findById(farmerId)
                .orElseThrow(() -> new IllegalArgumentException("Farmer not found: " + farmerId));

        Product product = Product.builder()
                .farmer(farmer)
                .name(req.getName())
                .category(req.getCategory() != null ? req.getCategory() : "Other")
                .quantity(req.getQuantity())
                .unitPrice(req.getUnitPrice())
                .qualityGrade(req.getQualityGrade() != null ? req.getQualityGrade() : "B")
                .imageUrl(req.getImageUrl())
                .location(req.getLocation())
                .status("AVAILABLE")
                .rating(BigDecimal.ZERO)
                .ratingCount(0)
                .description(req.getDescription())
                .build();

        Product saved = productRepository.save(product);
        return mapToDto(saved);
    }

    @Transactional
    public ProductDto updateProduct(Long farmerId, Long productId, ProductRequest req) {
        Product p = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + productId));

        if (!p.getFarmer().getId().equals(farmerId)) {
            throw new SecurityException("Not authorized to update this product listing");
        }

        p.setName(req.getName());
        p.setCategory(req.getCategory());
        p.setQuantity(req.getQuantity());
        p.setUnitPrice(req.getUnitPrice());
        if (req.getQualityGrade() != null) p.setQualityGrade(req.getQualityGrade());
        p.setLocation(req.getLocation());
        p.setDescription(req.getDescription());

        return mapToDto(productRepository.save(p));
    }

    @Transactional
    public void deleteProduct(Long farmerId, Long productId) {
        Product p = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + productId));

        if (!p.getFarmer().getId().equals(farmerId)) {
            throw new SecurityException("Not authorized to delete this product listing");
        }

        p.setStatus("REMOVED");
        productRepository.save(p);
    }

    public ProductDto mapToDto(Product p) {
        return ProductDto.builder()
                .id(p.getId())
                .farmerId(p.getFarmer() != null ? p.getFarmer().getId() : null)
                .farmerName(p.getFarmer() != null ? p.getFarmer().getName() : "Unknown")
                .name(p.getName())
                .category(p.getCategory())
                .quantity(p.getQuantity())
                .unitPrice(p.getUnitPrice())
                .qualityGrade(p.getQualityGrade())
                .imageUrl(p.getImageUrl())
                .location(p.getLocation())
                .status(p.getStatus())
                .rating(p.getRating())
                .ratingCount(p.getRatingCount())
                .description(p.getDescription())
                .createdAt(p.getCreatedAt())
                .build();
    }
}
