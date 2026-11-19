package com.agrinexus.backend.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/** Used for /api/auth/register */
@Data
public class RegisterRequest {
    @NotBlank @Size(min = 2, max = 100)
    private String name;

    @Email @NotBlank
    private String email;

    @Size(min = 10, max = 15)
    private String phone;

    @NotBlank @Size(min = 6, max = 50)
    private String password;

    /** FARMER | BUYER | CONSUMER | LOGISTICS | ADMIN */
    @NotBlank
    private String role;

    /** en | te | hi | ta | kn | mr */
    private String language = "en";
}
