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
public class DeliveryDto {
    private Long id;
    private Long orderId;
    private Long partnerId;
    private String partnerName;
    private String pickupLocation;
    private String dropLocation;
    private String status;
    private LocalDateTime assignedAt;
    private LocalDateTime deliveredAt;
}
