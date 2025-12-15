<%@ page import="java.sql.*" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.DatabaseConnection" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>

<%
    int idEvaluacion = (int) request.getAttribute("idEvaluacion");
    Connection con = DatabaseConnection.getConnection();
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM criterios_evaluacion WHERE estado='activo'");
    
    Usuario jurado = (Usuario) session.getAttribute("usuario");
    if (jurado == null || !"jurado".equals(jurado.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Evaluación Jurado</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .header {
            background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }
        .header-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header-title h1 {
            margin: 0;
            font-size: 24px;
        }
        .header-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .evaluacion-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .card-header {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f2f6;
        }
        .card-header h2 {
            color: #2d3436;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-header p {
            color: #636e72;
            margin: 5px 0;
            line-height: 1.6;
        }
        .instrucciones-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 6px;
        }
        .instrucciones-box h4 {
            color: #0d47a1;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .instrucciones-box ul {
            margin: 10px 0;
            padding-left: 20px;
            color: #1565c0;
        }
        .instrucciones-box li {
            margin-bottom: 8px;
        }
        .criterios-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
        }
        .criterios-table th {
            background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);
            color: white;
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            border: none;
            font-size: 15px;
        }
        .criterios-table td {
            padding: 20px;
            border-bottom: 1px solid #f1f2f6;
            vertical-align: top;
        }
        .criterios-table tr:hover {
            background-color: #f8f9fa;
        }
        .criterios-table tr:last-child td {
            border-bottom: none;
        }
        .numero-criterio {
            background: #6c5ce7;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 16px;
        }
        .criterio-descripcion {
            font-weight: 500;
            color: #2d3436;
            line-height: 1.5;
        }
        .puntaje-select {
            padding: 12px 16px;
            border: 2px solid #dfe6e9;
            border-radius: 8px;
            background: white;
            font-size: 15px;
            color: #2d3436;
            width: 120px;
            transition: all 0.3s;
            cursor: pointer;
        }
        .puntaje-select:focus {
            outline: none;
            border-color: #6c5ce7;
            box-shadow: 0 0 0 3px rgba(108, 92, 231, 0.1);
        }
        .comentario-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #dfe6e9;
            border-radius: 8px;
            font-size: 15px;
            color: #2d3436;
            transition: all 0.3s;
        }
        .comentario-input:focus {
            outline: none;
            border-color: #6c5ce7;
            box-shadow: 0 0 0 3px rgba(108, 92, 231, 0.1);
        }
        .comentario-input::placeholder {
            color: #b2bec3;
        }
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f1f2f6;
        }
        .btn-cancelar {
            background: #e9ecef;
            color: #495057;
            text-decoration: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn-cancelar:hover {
            background: #dee2e6;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .btn-guardar {
            background: linear-gradient(135deg, #00b894 0%, #00a085 100%);
            color: white;
            padding: 14px 40px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .btn-guardar:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 184, 148, 0.3);
        }
        .required-note {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .puntaje-guia {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
        }
        .puntaje-guia h5 {
            color: #856404;
            margin: 0 0 10px 0;
            font-size: 14px;
        }
        .puntaje-guia ul {
            margin: 0;
            padding-left: 20px;
            color: #856404;
        }
        .puntaje-guia li {
            font-size: 13px;
            margin-bottom: 5px;
        }
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            .header-info {
                flex-direction: column;
                gap: 10px;
            }
            .criterios-table {
                display: block;
                overflow-x: auto;
            }
            .form-actions {
                flex-direction: column;
                gap: 15px;
            }
            .btn-cancelar, .btn-guardar {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-title">
            <h1>? Evaluación de Tesis</h1>
        </div>
        <div class="header-info">
            <% if (jurado != null) { %>
            <span style="font-weight: 500;">? <%= jurado.getNombreCompleto() %></span>
            <% } %>
            <a href="<%= request.getContextPath() %>/jurado/dashboard" class="btn-secondary">? Volver al Dashboard</a>
        </div>
    </div>
    
    <div class="container">
        <div class="evaluacion-card">
            <div class="instrucciones-box">
                <h4>? Instrucciones de Evaluación</h4>
                <ul>
                    <li>Seleccione el puntaje para cada criterio (0, 0.5 o 1 punto)</li>
                    <li>Ingrese comentarios específicos para cada criterio evaluado</li>
                    <li>Su evaluación será final e irrevocable una vez enviada</li>
                    <li>Revise cuidadosamente antes de guardar la evaluación</li>
                </ul>
            </div>
            
            <form action="<%= request.getContextPath() %>/jurado/guardar" method="post">
                <input type="hidden" name="id_evaluacion" value="<%= idEvaluacion %>">
                
                <table class="criterios-table">
                    <thead>
                        <tr>
                            <th style="width: 60px;">N°</th>
                            <th style="width: 45%;">Criterio de Evaluación</th>
                            <th style="width: 15%;">Puntaje</th>
                            <th style="width: 40%;">Comentario/Observación</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int contador = 0; while (rs.next()) { 
                            int idC = rs.getInt("id_criterio");
                            contador++;
                        %>
                        <tr>
                            <td>
                                <div class="numero-criterio"><%= rs.getInt("numero") %></div>
                            </td>
                            <td>
                                <div class="criterio-descripcion"><%= rs.getString("descripcion") %></div>
                            </td>
                            <td>
                                <select name="puntaje_<%= idC %>" class="puntaje-select" required>
                                    <option value="" disabled selected>Seleccionar</option>
                                    <option value="0">0 punto</option>
                                    <option value="0.5">0.5 punto</option>
                                    <option value="1">1 punto</option>
                                </select>
                            </td>
                            <td>
                                <input type="text" name="comentario_<%= idC %>" class="comentario-input" placeholder="Ingrese sus observaciones...">
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="puntaje-guia">
                    <h5>? Guía de Puntaje:</h5>
                    <ul>
                        <li><strong>0 punto:</strong> No cumple con el criterio</li>
                        <li><strong>0.5 punto:</strong> Cumple parcialmente</li>
                        <li><strong>1 punto:</strong> Cumple completamente</li>
                    </ul>
                </div>
                
                <div class="required-note">?? Todos los campos de puntaje son obligatorios</div>
                
                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/jurado/dashboard" class="btn-cancelar">? Cancelar</a>
                    <button type="submit" class="btn-guardar">? Guardar Evaluación</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>