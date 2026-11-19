package com.agrinexus.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DiseaseResponse {
    private String disease;
    private Double confidence;
    private String advice;
    private String severity;
    private String imageUrl;
}
