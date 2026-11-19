package com.agrinexus.backend.controller;

import com.agrinexus.backend.model.dto.ProductDto;
import com.agrinexus.backend.model.dto.ProductRequest;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
@Tag(name = "Marketplace Products", description = "Endpoints for crop discovery and farmer listing management")
public class ProductController {

    private final ProductService productService;

    @GetMapping
    @Operation(summary = "Search available products by keyword and category")
    public ResponseEntity<List<ProductDto>> search(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category
    ) {
        return ResponseEntity.ok(productService.searchProducts(query, category));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Retrieve specific product details with AI quality grade and farmer trust score")
    public ResponseEntity<ProductDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(productService.getProductById(id));
    }

    @GetMapping("/farmer/{farmerId}")
    @Operation(summary = "Get all products listed by a specific farmer")
    public ResponseEntity<List<ProductDto>> getFarmerProducts(@PathVariable Long farmerId) {
        return ResponseEntity.ok(productService.getFarmerProducts(farmerId));
    }

    @PostMapping
    @PreAuthorize("hasRole('FARMER') or hasRole('ADMIN')")
    @Operation(summary = "Create a new crop listing (Farmer role required)")
    public ResponseEntity<ProductDto> create(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody ProductRequest request
    ) {
        return ResponseEntity.ok(productService.createProduct(user.getId(), request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('FARMER') or hasRole('ADMIN')")
    @Operation(summary = "Update an existing crop listing")
    public ResponseEntity<ProductDto> update(
            @AuthenticationPrincipal User user,
            @PathVariable Long id,
            @Valid @RequestBody ProductRequest request
    ) {
        return ResponseEntity.ok(productService.updateProduct(user.getId(), id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('FARMER') or hasRole('ADMIN')")
    @Operation(summary = "Remove a crop listing")
    public ResponseEntity<Void> delete(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        productService.deleteProduct(user.getId(), id);
        return ResponseEntity.noContent().build();
    }
}
