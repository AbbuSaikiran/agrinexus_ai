package com.agrinexus.backend.controller;

import com.agrinexus.backend.model.dto.DeliveryDto;
import com.agrinexus.backend.service.DeliveryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/deliveries")
@RequiredArgsConstructor
@Tag(name = "Logistics", description = "Endpoints for dispatch, transport routes and shipment tracking")
public class DeliveryController {

    private final DeliveryService deliveryService;

    @PostMapping("/assign")
    @PreAuthorize("hasRole('LOGISTICS') or hasRole('ADMIN')")
    @Operation(summary = "Assign a delivery order to a logistics partner")
    public ResponseEntity<DeliveryDto> assign(
            @RequestParam Long orderId,
            @RequestParam Long partnerId
    ) {
        return ResponseEntity.ok(deliveryService.assignDelivery(orderId, partnerId));
    }

    @PatchMapping("/{deliveryId}/status")
    @PreAuthorize("hasRole('LOGISTICS') or hasRole('ADMIN')")
    @Operation(summary = "Update transport status: ASSIGNED, PICKED_UP, IN_TRANSIT, DELIVERED")
    public ResponseEntity<DeliveryDto> updateStatus(
            @PathVariable Long deliveryId,
            @RequestParam String status
    ) {
        return ResponseEntity.ok(deliveryService.updateDeliveryStatus(deliveryId, status));
    }

    @GetMapping("/partner/{partnerId}")
    @Operation(summary = "Get list of dispatches assigned to partner")
    public ResponseEntity<List<DeliveryDto>> getDeliveries(@PathVariable Long partnerId) {
        return ResponseEntity.ok(deliveryService.getPartnerDeliveries(partnerId));
    }
}
