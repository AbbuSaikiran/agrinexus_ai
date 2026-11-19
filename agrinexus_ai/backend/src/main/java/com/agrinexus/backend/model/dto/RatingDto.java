package com.agrinexus.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RatingDto {
    private Long id;
    private Long orderId;
    private Long ratedById;
    private String ratedByName;
    private Long ratedUserId;
    private String ratedUserName;
    private Integer score;
    private String comment;
    private LocalDateTime createdAt;
}
