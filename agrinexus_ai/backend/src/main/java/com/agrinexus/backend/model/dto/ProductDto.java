package com.agrinexus.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDto {
    private Long id;
    private Long farmerId;
    private String farmerName;
    private String name;
    private String category;
    private BigDecimal quantity;
    private BigDecimal unitPrice;
    private String qualityGrade;
    private String imageUrl;
    private String location;
    private String status;
    private BigDecimal rating;
    private Integer ratingCount;
    private String description;
    private LocalDateTime createdAt;
}
