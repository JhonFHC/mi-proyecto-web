<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Evaluación de Tesis - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
            padding: 40px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .logo p {
            color: #666;
            font-size: 14px;
        }
        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }
        .alert-error {
            background: #fee;
            border: 1px solid #f99;
            color: #c33;
        }
        .alert-success {
            background: #efe;
            border: 1px solid #9f9;
            color: #393;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 10px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .demo-credentials {
            margin-top: 30px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 10px;
            font-size: 12px;
        }
        .demo-credentials h4 {
            color: #555;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .demo-credentials table {
            width: 100%;
            border-collapse: collapse;
            font-size: 11px;
        }
        .demo-credentials td {
            padding: 4px;
            border-bottom: 1px solid #ddd;
        }
        .demo-credentials tr:last-child td {
            border-bottom: none;
        }
        .demo-credentials strong {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>📚 TESIS UPLA</h1>
            <p>Sistema de Evaluación de Tesis</p>
        </div>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <c:choose>
                    <c:when test="${param.error == 'credenciales_invalidas'}">❌ Credenciales inválidas. Por favor, intente nuevamente.</c:when>
                    <c:when test="${param.error == 'campos_vacios'}">❌ Todos los campos son obligatorios.</c:when>
                    <c:when test="${param.error == 'acceso_denegado'}">❌ Acceso denegado. Por favor, inicie sesión.</c:when>
                    <c:otherwise>❌ Error al iniciar sesión.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <c:choose>
                    <c:when test="${param.success == 'sesion_cerrada'}">✅ Sesión cerrada exitosamente.</c:when>
                </c:choose>
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
                <label for="email">Email o Código UPLA</label>
                <input type="text" id="email" name="email" placeholder="usuario@upla.edu.pe" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-login">Iniciar Sesión</button>
        </form>
        
        <div class="demo-credentials">
            <h4>📋 Credenciales de Prueba:</h4>
            <table>
                <tr>
                    <td><strong>Rol</strong></td>
                    <td><strong>Usuario</strong></td>
                    <td><strong>Contraseña</strong></td>
                </tr>
                <tr>
                    <td>Admin</td>
                    <td>admin@upla.edu.pe</td>
                    <td>admin123</td>
                </tr>
                <tr>
                    <td>Estudiante</td>
                    <td>e12345a@ms.upla.edu.pe</td>
                    <td>est123</td>
                </tr>
                <tr>
                    <td>Asesor</td>
                    <td>p23456b@ms.upla.edu.pe</td>
                    <td>prof123</td>
                </tr>
                <tr>
                    <td>Jurado</td>
                    <td>j34567c@ms.upla.edu.pe</td>
                    <td>prof123</td>
                </tr>
            </table>
            <p style="margin-top: 10px; color: #777;"><small>Base de datos: sistema_evaluacion_tesis</small></p>
        </div>
    </div>
</body>
</html>