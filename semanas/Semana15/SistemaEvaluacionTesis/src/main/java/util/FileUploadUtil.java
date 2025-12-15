package com.zonajava.sistemaevaluaciontesis.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

public class FileUploadUtil {
    public static String guardarArchivo(Part archivoPart, String uploadPath, String prefix) 
            throws IOException {
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String fileName = archivoPart.getSubmittedFileName();
        String extension = fileName.substring(fileName.lastIndexOf("."));
        String newFileName = prefix + "_" + System.currentTimeMillis() + extension;
        String filePath = uploadPath + File.separator + newFileName;
        
        archivoPart.write(filePath);
        return newFileName;
    }
    
    public static boolean esPDF(Part archivoPart) {
        String fileName = archivoPart.getSubmittedFileName();
        return fileName != null && fileName.toLowerCase().endsWith(".pdf");
    }
    
    public static boolean tamanoValido(Part archivoPart, long maxSizeMB) {
        long maxSizeBytes = maxSizeMB * 1024 * 1024;
        return archivoPart.getSize() <= maxSizeBytes;
    }
}