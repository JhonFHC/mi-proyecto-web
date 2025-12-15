package com.zonajava.sistemaevaluaciontesis.model;

import java.sql.Timestamp;

public class Usuario {
    private int idUsuario;
    private String codigoUpla;
    private String nombreCompleto;
    private String email;
    private String password;
    private String rol;
    private String departamento;
    private String estado;
    private Timestamp fechaCreacion;
    
    public Usuario() {
    }
    
    public Usuario(int idUsuario, String codigoUpla, String nombreCompleto, String email,
                   String password, String rol, String departamento, String estado) {
        this.idUsuario = idUsuario;
        this.codigoUpla = codigoUpla;
        this.nombreCompleto = nombreCompleto;
        this.email = email;
        this.password = password;
        this.rol = rol;
        this.departamento = departamento;
        this.estado = estado;
    }
    
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getCodigoUpla() {
        return codigoUpla;
    }
    
    public void setCodigoUpla(String codigoUpla) {
        this.codigoUpla = codigoUpla;
    }
    
    public String getNombreCompleto() {
        return nombreCompleto;
    }
    
    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRol() {
        return rol;
    }
    
    public void setRol(String rol) {
        this.rol = rol;
    }
    
    public String getDepartamento() {
        return departamento;
    }
    
    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }
    
    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
}