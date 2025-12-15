package com.zonajava.sistemaevaluaciontesis.model;

import java.sql.Timestamp;

public class Tesis {
    private int idTesis;
    private String titulo;
    private String descripcion;
    private String resumen;
    private String palabrasClave;
    private int idEstudiante;
    private int idAsesor;
    private String estado;
    private String archivoUrl;
    private Timestamp fechaEnvio;
    private Timestamp fechaCreacion;
    
    // Campos auxiliares (JOIN)
    private String estudianteNombre;
    private String asesorNombre;
    
    public Tesis() {
    }
    
    public int getIdTesis() {
        return idTesis;
    }
    
    public void setIdTesis(int idTesis) {
        this.idTesis = idTesis;
    }
    
    public String getTitulo() {
        return titulo;
    }
    
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getResumen() {
        return resumen;
    }
    
    public void setResumen(String resumen) {
        this.resumen = resumen;
    }
    
    public String getPalabrasClave() {
        return palabrasClave;
    }
    
    public void setPalabrasClave(String palabrasClave) {
        this.palabrasClave = palabrasClave;
    }
    
    public int getIdEstudiante() {
        return idEstudiante;
    }
    
    public void setIdEstudiante(int idEstudiante) {
        this.idEstudiante = idEstudiante;
    }
    
    public int getIdAsesor() {
        return idAsesor;
    }
    
    public void setIdAsesor(int idAsesor) {
        this.idAsesor = idAsesor;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public String getArchivoUrl() {
        return archivoUrl;
    }
    
    public void setArchivoUrl(String archivoUrl) {
        this.archivoUrl = archivoUrl;
    }
    
    public Timestamp getFechaEnvio() {
        return fechaEnvio;
    }
    
    public void setFechaEnvio(Timestamp fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }
    
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }
    
    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    public String getEstudianteNombre() {
        return estudianteNombre;
    }
    
    public void setEstudianteNombre(String estudianteNombre) {
        this.estudianteNombre = estudianteNombre;
    }
    
    public String getAsesorNombre() {
        return asesorNombre;
    }
    
    public void setAsesorNombre(String asesorNombre) {
        this.asesorNombre = asesorNombre;
    }
}