package com.agrinexus.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CropRecommendationResponse {
    private String cropName;
    private Double suitabilityScore;
    private String season;
    private String expectedYield;
    private BigDecimal expectedPrice;
    private String reason;
}
