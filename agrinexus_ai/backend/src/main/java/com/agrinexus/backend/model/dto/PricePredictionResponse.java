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
public class PricePredictionResponse {
    private String crop;
    private String market;
    private BigDecimal predictedPrice;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private String trend;
    private String dataPeriod;
    private String recommendation;
}
