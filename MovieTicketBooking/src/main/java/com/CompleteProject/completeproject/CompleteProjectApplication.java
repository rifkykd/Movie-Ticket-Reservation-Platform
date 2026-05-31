package com.CompleteProject.completeproject;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan
public class CompleteProjectApplication {

	public static void main(String[] args) {
		SpringApplication.run(CompleteProjectApplication.class, args);
	}

}
