package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.repository.FileHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.Files;

// Handles requests like /movie-image/filename.jpg
// Purpose: stream movie poster or image files directly to the client

@Controller
public class ImageController {

    @GetMapping("/movie-image/{filename:.+}")
    public void serveImage(@PathVariable String filename,
                           HttpServletResponse response) {
        try {
            File imageFile = new File(FileHandler.IMAGE_DIR + File.separator + filename);

            if (!imageFile.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String contentType = Files.probeContentType(imageFile.toPath());
            if (contentType == null) contentType = "image/jpeg";

            response.setContentType(contentType);
            response.setContentLength((int) imageFile.length());

            try (InputStream  in  = new FileInputStream(imageFile);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

        } catch (Exception e) {
            try { response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); }
            catch (IOException ignored) {}
        }
    }
}
