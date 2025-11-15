package com.zonajava.sistemaevaluaciontesis.model;

import java.util.Date;

public class Evaluacion {
    private int idEvaluacion;
    private int idTesis;
    private int idJurado;
    private double calificacionFinal;
    private String comentarios;
    private Date fechaEvaluacion;
    private String estado;
    private String nombreJurado;
    private String tituloTesis;
    
    // Constructores
    public Evaluacion() {}
    
    public Evaluacion(int idEvaluacion, int idTesis, int idJurado, double calificacionFinal, 
                      String comentarios, Date fechaEvaluacion, String estado) {
        this.idEvaluacion = idEvaluacion;
        this.idTesis = idTesis;
        this.idJurado = idJurado;
        this.calificacionFinal = calificacionFinal;
        this.comentarios = comentarios;
        this.fechaEvaluacion = fechaEvaluacion;
        this.estado = estado;
    }
    
    // Getters y Setters
    public int getIdEvaluacion() { return idEvaluacion; }
    public void setIdEvaluacion(int idEvaluacion) { this.idEvaluacion = idEvaluacion; }
    
    public int getIdTesis() { return idTesis; }
    public void setIdTesis(int idTesis) { this.idTesis = idTesis; }
    
    public int getIdJurado() { return idJurado; }
    public void setIdJurado(int idJurado) { this.idJurado = idJurado; }
    
    public double getCalificacionFinal() { return calificacionFinal; }
    public void setCalificacionFinal(double calificacionFinal) { this.calificacionFinal = calificacionFinal; }
    
    public String getComentarios() { return comentarios; }
    public void setComentarios(String comentarios) { this.comentarios = comentarios; }
    
    public Date getFechaEvaluacion() { return fechaEvaluacion; }
    public void setFechaEvaluacion(Date fechaEvaluacion) { this.fechaEvaluacion = fechaEvaluacion; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getNombreJurado() { return nombreJurado; }
    public void setNombreJurado(String nombreJurado) { this.nombreJurado = nombreJurado; }
    
    public String getTituloTesis() { return tituloTesis; }
    public void setTituloTesis(String tituloTesis) { this.tituloTesis = tituloTesis; }
}
