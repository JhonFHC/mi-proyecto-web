package com.zonajava.sistemaevaluaciontesis.model;

import java.sql.Timestamp;

public class Evaluacion {
    private int idEvaluacion;
    private int idTesis;
    private int idJurado;
    private double calificacionFinal;
    private String comentarios;
    private Timestamp fechaEvaluacion;
    private String estado; // 'pendiente', 'en_progreso', 'completada'
    private String recomendacion; // 'aprobado', 'aprobado_obs', 'desaprobado'
    
    // Campos para joins
    private String juradoNombre;
    private String tesisTitulo;
    
    public Evaluacion() {}
    
    // Getters y Setters
    public int getIdEvaluacion() { 
        return idEvaluacion; 
    }
    
    public void setIdEvaluacion(int idEvaluacion) { 
        this.idEvaluacion = idEvaluacion; 
    }
    
    public int getIdTesis() { 
        return idTesis; 
    }
    
    public void setIdTesis(int idTesis) { 
        this.idTesis = idTesis; 
    }
    
    public int getIdJurado() { 
        return idJurado; 
    }
    
    public void setIdJurado(int idJurado) { 
        this.idJurado = idJurado; 
    }
    
    public double getCalificacionFinal() { 
        return calificacionFinal; 
    }
    
    public void setCalificacionFinal(double calificacionFinal) { 
        this.calificacionFinal = calificacionFinal; 
    }
    
    public String getComentarios() { 
        return comentarios; 
    }
    
    public void setComentarios(String comentarios) { 
        this.comentarios = comentarios; 
    }
    
    public Timestamp getFechaEvaluacion() { 
        return fechaEvaluacion; 
    }
    
    public void setFechaEvaluacion(Timestamp fechaEvaluacion) { 
        this.fechaEvaluacion = fechaEvaluacion; 
    }
    
    public String getEstado() { 
        return estado; 
    }
    
    public void setEstado(String estado) { 
        this.estado = estado; 
    }
    
    public String getRecomendacion() { 
        return recomendacion; 
    }
    
    public void setRecomendacion(String recomendacion) { 
        this.recomendacion = recomendacion; 
    }
    
    public String getJuradoNombre() { 
        return juradoNombre; 
    }
    
    public void setJuradoNombre(String juradoNombre) { 
        this.juradoNombre = juradoNombre; 
    }
    
    public String getTesisTitulo() { 
        return tesisTitulo; 
    }
    
    public void setTesisTitulo(String tesisTitulo) { 
        this.tesisTitulo = tesisTitulo; 
    }
}