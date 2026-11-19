package com.agrinexus.backend.controller;

import com.agrinexus.backend.model.dto.*;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.service.AiService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
@Tag(name = "AI Services", description = "Endpoints for Disease Detection, Quality Grading, Price Prediction & Assistant")
public class AiController {

    private final AiService aiService;

    @PostMapping(value = "/disease", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "YOLOv8 Plant Disease Detection from leaf photo")
    public ResponseEntity<DiseaseResponse> detectDisease(
            @AuthenticationPrincipal User user,
            @RequestParam("file") MultipartFile file
    ) {
        Long userId = user != null ? user.getId() : null;
        return ResponseEntity.ok(aiService.detectDisease(userId, file));
    }

    @PostMapping(value = "/quality", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "AI-powered crop quality grading (A+, A, B, C)")
    public ResponseEntity<QualityResponse> assessQuality(
            @RequestParam("file") MultipartFile file
    ) {
        return ResponseEntity.ok(aiService.assessQuality(file));
    }

    @GetMapping("/price")
    @Operation(summary = "Machine Learning Market Price Prediction")
    public ResponseEntity<PricePredictionResponse> predictPrice(
            @RequestParam String crop,
            @RequestParam(required = false, defaultValue = "Warangal APMC") String market
    ) {
        return ResponseEntity.ok(aiService.predictPrice(crop, market));
    }

    @GetMapping("/recommend")
    @Operation(summary = "Crop recommendation based on soil NPK, rainfall and temperature")
    public ResponseEntity<List<CropRecommendationResponse>> recommend(
            @RequestParam(defaultValue = "60") Double nitrogen,
            @RequestParam(defaultValue = "50") Double phosphorus,
            @RequestParam(defaultValue = "70") Double potassium,
            @RequestParam(defaultValue = "120") Double rainfall,
            @RequestParam(defaultValue = "25") Double temperature
    ) {
        return ResponseEntity.ok(aiService.recommendCrops(nitrogen, phosphorus, potassium, rainfall, temperature));
    }

    @PostMapping("/chat")
    @Operation(summary = "Multilingual Agricultural AI Assistant Query")
    public ResponseEntity<ChatResponse> chat(@RequestBody ChatRequest request) {
        return ResponseEntity.ok(aiService.chat(request.getMessage(), request.getLanguage()));
    }
}
