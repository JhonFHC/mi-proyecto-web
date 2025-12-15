package com.zonajava.sistemaevaluaciontesis.model;

public class CriterioEvaluacion {
    private int idCriterio;
    private int numero;
    private String seccion;
    private String descripcion;
    private double peso;
    private String estado;
    
    public CriterioEvaluacion() {}
    
    public CriterioEvaluacion(int numero, String seccion, String descripcion) {
        this.numero = numero;
        this.seccion = seccion;
        this.descripcion = descripcion;
        this.peso = 1.0;
        this.estado = "activo";
    }
    
    // Getters y Setters
    public int getIdCriterio() { 
        return idCriterio; 
    }
    
    public void setIdCriterio(int idCriterio) { 
        this.idCriterio = idCriterio; 
    }
    
    public int getNumero() { 
        return numero; 
    }
    
    public void setNumero(int numero) { 
        this.numero = numero; 
    }
    
    public String getSeccion() { 
        return seccion; 
    }
    
    public void setSeccion(String seccion) { 
        this.seccion = seccion; 
    }
    
    public String getDescripcion() { 
        return descripcion; 
    }
    
    public void setDescripcion(String descripcion) { 
        this.descripcion = descripcion; 
    }
    
    public double getPeso() { 
        return peso; 
    }
    
    public void setPeso(double peso) { 
        this.peso = peso; 
    }
    
    public String getEstado() { 
        return estado; 
    }
    
    public void setEstado(String estado) { 
        this.estado = estado; 
    }
}