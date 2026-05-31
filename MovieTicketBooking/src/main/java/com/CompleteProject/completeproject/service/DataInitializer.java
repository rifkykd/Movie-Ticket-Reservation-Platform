package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.util.FilePathConstants;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.file.*;

@Component
public class DataInitializer implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        String filePath = FilePathConstants.MOVIES_FILE;  // "data/movies.txt"

        File targetFile = new File(filePath);

        // If movies.txt doesn’t exist yet, we’ll try to auto-create it
        if (!targetFile.exists()) {
            new File("data").mkdirs();   // creates data/ folder if missing

            InputStream input = getClass()
                    .getClassLoader()
                    .getResourceAsStream("movies.txt");

            if (input != null) {
                Files.copy(input, targetFile.toPath());
                System.out.println("✔ movies.txt loaded from resources.");
                input.close();
            } else {
                System.out.println("⚠ movies.txt not found in resources — starting empty.");
            }
        } else {
            System.out.println("✔ movies.txt already exists — skipping auto-load.");
        }
    }
}
