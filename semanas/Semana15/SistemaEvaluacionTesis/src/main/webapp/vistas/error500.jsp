<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error 500 - Error del servidor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: #f4f6f9;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 100px;
            color: #e74c3c;
            margin: 0;
        }
        h2 {
            color: #2c3e50;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .technical {
            text-align: left;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <h2>Error interno del servidor</h2>
        <p>Ha ocurrido un error inesperado. Por favor, intenta nuevamente más tarde.</p>
        <% if (exception != null) { %>
        <div class="technical">
            <strong>Detalles técnicos:</strong><br>
            <%= exception.getClass().getName() %>: <%= exception.getMessage() %>
        </div>
        <% } %>
        <a href="<%= request.getContextPath() %>/vistas/login.jsp" class="btn">Volver al inicio</a>
    </div>
</body>
</html>