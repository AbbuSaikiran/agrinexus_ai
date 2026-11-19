package com.agrinexus.backend.controller;

import com.agrinexus.backend.model.dto.OrderDto;
import com.agrinexus.backend.model.dto.OrderRequest;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "Orders", description = "Endpoints for order placement and order lifecycle tracking")
public class OrderController {

    private final OrderService orderService;

    @PostMapping
    @Operation(summary = "Place a new order for a crop listing")
    public ResponseEntity<OrderDto> placeOrder(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody OrderRequest request
    ) {
        return ResponseEntity.ok(orderService.placeOrder(user.getId(), request));
    }

    @GetMapping("/my-orders")
    @Operation(summary = "Get list of orders placed by current buyer")
    public ResponseEntity<List<OrderDto>> getBuyerOrders(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(orderService.getBuyerOrders(user.getId()));
    }

    @GetMapping("/farmer-orders")
    @Operation(summary = "Get list of orders received by current farmer")
    public ResponseEntity<List<OrderDto>> getFarmerOrders(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(orderService.getFarmerOrders(user.getId()));
    }

    @PatchMapping("/{orderId}/status")
    @Operation(summary = "Update order status: PENDING, CONFIRMED, IN_TRANSIT, DELIVERED, CANCELLED")
    public ResponseEntity<OrderDto> updateStatus(
            @PathVariable Long orderId,
            @RequestParam String status
    ) {
        return ResponseEntity.ok(orderService.updateStatus(orderId, status));
    }
}
