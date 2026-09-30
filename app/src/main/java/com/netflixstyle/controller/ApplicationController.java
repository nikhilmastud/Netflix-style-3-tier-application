package com.netflixstyle.controller;

import com.netflixstyle.model.ApplicationInfo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApplicationController {
    @GetMapping("/api")
    public ApplicationInfo application() {
        return new ApplicationInfo(
            "Netflix-Style 3-Tier Application",
            "ALB -> EC2 Auto Scaling -> RDS",
            "RUNNING"
        );
    }
}