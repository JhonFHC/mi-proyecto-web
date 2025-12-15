package com.zonajava.sistemaevaluaciontesis.servlet;

import com.zonajava.sistemaevaluaciontesis.dao.DatabaseConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/reporte-pdf")
public class ReporteAdminPDFServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=reporte_tesis.pdf");
        
        PDDocument doc = new PDDocument();
        PDPage page = new PDPage(PDRectangle.A4);
        doc.addPage(page);
        
        PDPageContentStream cs = new PDPageContentStream(doc, page);
        float y = 750;
        
        String logoPath = getServletContext().getRealPath("/uploads/Ing.png");
        PDImageXObject logo = PDImageXObject.createFromFile(logoPath, doc);
        cs.drawImage(logo, 50, y - 50, 60, 60);
        
        cs.beginText();
        cs.setFont(PDType1Font.HELVETICA_BOLD, 14);
        cs.newLineAtOffset(130, y);
        cs.showText("Universidad Peruana Los Andes");
        cs.endText();
        
        y -= 30;
        cs.beginText();
        cs.setFont(PDType1Font.HELVETICA, 11);
        cs.newLineAtOffset(130, y);
        cs.showText("Autor: Jhon Huaman Cardenas");
        cs.endText();
        
        y -= 40;
        cs.beginText();
        cs.setFont(PDType1Font.HELVETICA_BOLD, 12);
        cs.newLineAtOffset(50, y);
        cs.showText("REPORTE GENERAL DE TESIS");
        cs.endText();
        
        y -= 30;
        cs.setFont(PDType1Font.HELVETICA, 10);
        
        try (Connection con = DatabaseConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("""
                SELECT t.titulo, t.estado, ROUND(AVG(e.calificacion_final),2)
                FROM tesis t
                LEFT JOIN evaluaciones e ON t.id_tesis = e.id_tesis
                GROUP BY t.id_tesis
                """)) {
            while (rs.next()) {
                cs.beginText();
                cs.newLineAtOffset(50, y);
                cs.showText("• " + rs.getString(1) + " | " +
                    rs.getString(2) + " | Promedio: " + rs.getString(3));
                cs.endText();
                y -= 15;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        cs.close();
        doc.save(response.getOutputStream());
        doc.close();
    }
}