package com.agrinexus.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties
public class AgriNexusApplication {
    public static void main(String[] args) {
        SpringApplication.run(AgriNexusApplication.class, args);
    }
}
