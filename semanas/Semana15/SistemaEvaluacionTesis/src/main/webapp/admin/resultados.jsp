<%@ page import="java.util.List" %>
<h2>Tesis listas para resultado final</h2>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
<table border="1">
    <tr>
        <th>Título</th>
        <th>Acción</th>
    </tr>
    
    <%
        List<Object[]> lista = (List<Object[]>) request.getAttribute("lista");
        if (lista == null || lista.isEmpty()) {
    %>
        <tr>
            <td colspan="2">No hay tesis listas</td>
        </tr>
    <%
        } else {
            for (Object[] row : lista) {
    %>
        <tr>
            <td><%= row[1] %></td>
            <td>
                <form action="<%= request.getContextPath() %>/admin/procesar-resultado" method="post">
                    <input type="hidden" name="id_tesis" value="<%= row[0] %>">
                    <button type="submit">Generar Resultado</button>
                </form>
            </td>
        </tr>
    <%
            }
        }
    %>
</table>