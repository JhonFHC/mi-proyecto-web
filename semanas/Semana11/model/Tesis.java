package com.zonajava.sistemaevaluaciontesis.model;

import java.util.Date;

public class Tesis {
    private int idTesis;
    private String titulo;
    private String descripcion;
    private int idEstudiante;
    private int idAsesor;
    private String estado;
    private String archivoUrl;
    private Date fechaEnvio;
    private Date fechaCreacion;
    private String nombreEstudiante;
    private String nombreAsesor;
    
    // Constructores
    public Tesis() {}
    
    public Tesis(int idTesis, String titulo, String descripcion, int idEstudiante, 
                 int idAsesor, String estado, String archivoUrl, Date fechaEnvio, Date fechaCreacion) {
        this.idTesis = idTesis;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.idEstudiante = idEstudiante;
        this.idAsesor = idAsesor;
        this.estado = estado;
        this.archivoUrl = archivoUrl;
        this.fechaEnvio = fechaEnvio;
        this.fechaCreacion = fechaCreacion;
    }
    
    // Getters y Setters
    public int getIdTesis() { return idTesis; }
    public void setIdTesis(int idTesis) { this.idTesis = idTesis; }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public int getIdEstudiante() { return idEstudiante; }
    public void setIdEstudiante(int idEstudiante) { this.idEstudiante = idEstudiante; }
    
    public int getIdAsesor() { return idAsesor; }
    public void setIdAsesor(int idAsesor) { this.idAsesor = idAsesor; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getArchivoUrl() { return archivoUrl; }
    public void setArchivoUrl(String archivoUrl) { this.archivoUrl = archivoUrl; }
    
    public Date getFechaEnvio() { return fechaEnvio; }
    public void setFechaEnvio(Date fechaEnvio) { this.fechaEnvio = fechaEnvio; }
    
    public Date getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Date fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    
    public String getNombreEstudiante() { return nombreEstudiante; }
    public void setNombreEstudiante(String nombreEstudiante) { this.nombreEstudiante = nombreEstudiante; }
    
    public String getNombreAsesor() { return nombreAsesor; }
    public void setNombreAsesor(String nombreAsesor) { this.nombreAsesor = nombreAsesor; }
}
