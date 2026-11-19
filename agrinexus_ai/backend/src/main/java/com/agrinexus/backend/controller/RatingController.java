package com.agrinexus.backend.controller;

import com.agrinexus.backend.model.dto.RatingDto;
import com.agrinexus.backend.model.dto.RatingRequest;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.service.RatingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ratings")
@RequiredArgsConstructor
@Tag(name = "Ratings & Trust", description = "Endpoints for trust scoring and crop/buyer evaluation")
public class RatingController {

    private final RatingService ratingService;

    @PostMapping
    @Operation(summary = "Submit a rating (1-5 stars) and review after order completion")
    public ResponseEntity<RatingDto> rate(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody RatingRequest request
    ) {
        return ResponseEntity.ok(ratingService.submitRating(user.getId(), request));
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "Retrieve verified customer ratings for a farmer or buyer")
    public ResponseEntity<List<RatingDto>> getUserRatings(@PathVariable Long userId) {
        return ResponseEntity.ok(ratingService.getUserRatings(userId));
    }
}
