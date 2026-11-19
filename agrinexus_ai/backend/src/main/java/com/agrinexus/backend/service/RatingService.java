package com.agrinexus.backend.service;

import com.agrinexus.backend.model.dto.RatingDto;
import com.agrinexus.backend.model.dto.RatingRequest;
import com.agrinexus.backend.model.entity.Order;
import com.agrinexus.backend.model.entity.Product;
import com.agrinexus.backend.model.entity.Rating;
import com.agrinexus.backend.model.entity.User;
import com.agrinexus.backend.repository.OrderRepository;
import com.agrinexus.backend.repository.ProductRepository;
import com.agrinexus.backend.repository.RatingRepository;
import com.agrinexus.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RatingService {

    private final RatingRepository ratingRepository;
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Transactional
    public RatingDto submitRating(Long ratedById, RatingRequest req) {
        Order order = orderRepository.findById(req.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + req.getOrderId()));

        User ratedBy = userRepository.findById(ratedById)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + ratedById));

        User ratedUser;
        if (order.getBuyer().getId().equals(ratedById)) {
            ratedUser = order.getProduct().getFarmer();
        } else {
            ratedUser = order.getBuyer();
        }

        Rating rating = Rating.builder()
                .order(order)
                .ratedBy(ratedBy)
                .ratedUser(ratedUser)
                .score(req.getScore())
                .comment(req.getComment())
                .build();

        Rating saved = ratingRepository.save(rating);

        // Recalculate target trust score
        Double avg = ratingRepository.calculateAverageScoreForUser(ratedUser.getId());
        if (avg != null) {
            ratedUser.setTrustScore(Math.round(avg * 10.0) / 10.0);
            userRepository.save(ratedUser);
        }

        // Update product rating if farmer was rated
        if (order.getBuyer().getId().equals(ratedById)) {
            Product p = order.getProduct();
            int newCount = p.getRatingCount() + 1;
            BigDecimal currentTotal = p.getRating().multiply(BigDecimal.valueOf(p.getRatingCount()));
            BigDecimal newAvg = currentTotal.add(BigDecimal.valueOf(req.getScore()))
                    .divide(BigDecimal.valueOf(newCount), 2, RoundingMode.HALF_UP);
            p.setRating(newAvg);
            p.setRatingCount(newCount);
            productRepository.save(p);
        }

        return RatingDto.builder()
                .id(saved.getId())
                .orderId(order.getId())
                .ratedById(ratedBy.getId())
                .ratedByName(ratedBy.getName())
                .ratedUserId(ratedUser.getId())
                .ratedUserName(ratedUser.getName())
                .score(saved.getScore())
                .comment(saved.getComment())
                .createdAt(saved.getCreatedAt())
                .build();
    }

    public List<RatingDto> getUserRatings(Long userId) {
        return ratingRepository.findByRatedUserId(userId).stream()
                .map(r -> RatingDto.builder()
                        .id(r.getId())
                        .orderId(r.getOrder().getId())
                        .ratedById(r.getRatedBy().getId())
                        .ratedByName(r.getRatedBy().getName())
                        .ratedUserId(r.getRatedUser().getId())
                        .ratedUserName(r.getRatedUser().getName())
                        .score(r.getScore())
                        .comment(r.getComment())
                        .createdAt(r.getCreatedAt())
                        .build())
                .collect(Collectors.toList());
    }
}
