<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession ses = request.getSession(false);
    if (ses != null) {
        ses.invalidate();
    }
    response.sendRedirect("login.jsp");
%>