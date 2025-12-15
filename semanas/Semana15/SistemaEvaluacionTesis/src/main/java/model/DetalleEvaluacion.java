package com.zonajava.sistemaevaluaciontesis.model;

public class DetalleEvaluacion {
    private int idDetalle;
    private int idEvaluacion;
    private int idCriterio;
    private double puntaje; // 0.0, 0.5, 1.0
    private String comentario;
    
    // Campos para joins
    private String criterioDescripcion;
    private int criterioNumero;
    private String criterioSeccion;
    
    public DetalleEvaluacion() {}
    
    // Getters y Setters
    public int getIdDetalle() { 
        return idDetalle; 
    }
    
    public void setIdDetalle(int idDetalle) { 
        this.idDetalle = idDetalle; 
    }
    
    public int getIdEvaluacion() { 
        return idEvaluacion; 
    }
    
    public void setIdEvaluacion(int idEvaluacion) { 
        this.idEvaluacion = idEvaluacion; 
    }
    
    public int getIdCriterio() { 
        return idCriterio; 
    }
    
    public void setIdCriterio(int idCriterio) { 
        this.idCriterio = idCriterio; 
    }
    
    public double getPuntaje() { 
        return puntaje; 
    }
    
    public void setPuntaje(double puntaje) { 
        this.puntaje = puntaje; 
    }
    
    public String getComentario() { 
        return comentario; 
    }
    
    public void setComentario(String comentario) { 
        this.comentario = comentario; 
    }
    
    public String getCriterioDescripcion() { 
        return criterioDescripcion; 
    }
    
    public void setCriterioDescripcion(String criterioDescripcion) { 
        this.criterioDescripcion = criterioDescripcion; 
    }
    
    public int getCriterioNumero() { 
        return criterioNumero; 
    }
    
    public void setCriterioNumero(int criterioNumero) { 
        this.criterioNumero = criterioNumero; 
    }
    
    public String getCriterioSeccion() { 
        return criterioSeccion; 
    }
    
    public void setCriterioSeccion(String criterioSeccion) { 
        this.criterioSeccion = criterioSeccion; 
    }
}