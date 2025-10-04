/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package Vista;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;


public class CuadradoVista extends javax.swing.JFrame {
    // Botones figura
    private String figuraSeleccionada;
    private PanelDibujo panelFigura;
    
    public CuadradoVista() {
        initComponents();
        formulario();
        this.setTitle("Área y Perímetro de Figuras");
        setLocationRelativeTo(null); // Centra la ventana

        btnCalcular.setEnabled(false);
        btnNuevo.setEnabled(false);

        btnSalir.addActionListener(e -> System.exit(0));

        btnCuadrado.addActionListener(e -> seleccionarFigura("cuadrado"));
        btnCirculo.addActionListener(e -> seleccionarFigura("circulo"));
        btnTriangulo.addActionListener(e -> seleccionarFigura("triangulo"));

        txtLado.addKeyListener(new KeyAdapter() {
            @Override
            public void keyReleased(KeyEvent e) {
                habilitarBotones();
            }

            @Override
            public void keyTyped(KeyEvent evt) {
                char key = evt.getKeyChar();
                if (!Character.isDigit(key) && key != '.') {
                    evt.consume();
                }
            }
        });

        btnNuevo.addActionListener(e -> limpiarCampos());

        btnCalcular.addActionListener(e -> {
            double lado = obtenerLado();
            if (lado <= 0) {
                JOptionPane.showMessageDialog(this, "Ingrese un valor válido mayor que 0", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            double area = 0, perimetro = 0;
            switch (figuraSeleccionada) {
                case "cuadrado":
                    area = lado * lado;
                    perimetro = 4 * lado;
                    break;
                case "circulo":
                    area = Math.PI * lado * lado;
                    perimetro = 2 * Math.PI * lado;
                    break;
                case "triangulo":
                    double altura = Math.sqrt(3) * lado / 2;
                    area = (lado * altura) / 2;
                    perimetro = 3 * lado;
                    break;
            }
            mostrarResultados(area, perimetro);
        });
    }
    
    private void formulario() {
        this.setSize(650, 450);
        this.setLayout(null);
        this.setLocationRelativeTo(null);
        this.setDefaultCloseOperation(EXIT_ON_CLOSE);

        panelSeleccionar.setLayout(null);
        panelSeleccionar.setBounds(20, 20, 200, 150);

        btnCuadrado.setBounds(20, 10, 150, 30);
        btnCirculo.setBounds(20, 50, 150, 30);
        btnTriangulo.setBounds(20, 90, 150, 30);

        panelSeleccionar.add(btnCuadrado);
        panelSeleccionar.add(btnCirculo);
        panelSeleccionar.add(btnTriangulo);

        this.add(panelSeleccionar);

        panelDatos.setLayout(null);
        panelDatos.setBounds(250, 20, 350, 120);
        panelDatos.setVisible(false);

        txtLado.setBounds(10, 10, 100, 25);
        panelDatos.add(txtLado);

        txtLado.setBounds(120, 10, 100, 25);
        panelDatos.add(txtLado);

        JScrollPane scroll = new JScrollPane(txtSalida);
        scroll.setBounds(10, 50, 300, 60);
        panelDatos.add(scroll);

        this.add(panelDatos);

        panelCalcular.setLayout(null);
        panelCalcular.setBounds(250, 160, 350, 50);
        panelCalcular.setVisible(false);

        btnCalcular.setBounds(10, 10, 100, 30);
        btnCalcular.setEnabled(false);

        btnNuevo.setBounds(120, 10, 100, 30);
        btnNuevo.setEnabled(false);

        btnSalir.setBounds(230, 10, 100, 30);

        panelCalcular.add(btnCalcular);
        panelCalcular.add(btnNuevo);
        panelCalcular.add(btnSalir);

        this.add(panelCalcular);

        panelFigura = new PanelDibujo();
        panelFigura.setBounds(20, 220, 580, 180);
        panelFigura.setBackground(Color.LIGHT_GRAY);
        panelFigura.setVisible(false);

        this.add(panelFigura);
    }


    private void seleccionarFigura(String figura) {
        this.figuraSeleccionada = figura;
        panelDatos.setVisible(true);
        panelCalcular.setVisible(true);
        panelFigura.setVisible(true);
        limpiarCampos();
    }

    private void habilitarBotones() {
        boolean habilitar = !txtLado.getText().trim().isEmpty();
        btnCalcular.setEnabled(habilitar);
        btnNuevo.setEnabled(habilitar);
    }

    public double obtenerLado() {
        try {
            return Double.parseDouble(txtLado.getText());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public void mostrarResultados(double area, double perimetro) {
        txtSalida.setText("Resultados:\n");
        txtSalida.append("Área: " + String.format("%.2f", area) + "\n");
        txtSalida.append("Perímetro: " + String.format("%.2f", perimetro));
        int ladoInt = (int) obtenerLado();
        panelFigura.setFigura(figuraSeleccionada);
        panelFigura.setLado(ladoInt);
    }

    public void limpiarCampos() {
        txtLado.setText("");
        txtSalida.setText("");
        panelFigura.setFigura("");
        panelFigura.setLado(0);
        btnCalcular.setEnabled(false);
        btnNuevo.setEnabled(false);
    }
    
    public void agregarCalcularListener(ActionListener listener) {
        btnCalcular.addActionListener(listener);
    }

    public void agregarNuevoListener(ActionListener listener) {
        btnNuevo.addActionListener(listener);
    }

    public void agregarSairListener(ActionListener listener) {
        btnSalir.addActionListener(listener);
    }

    private class PanelDibujo extends JPanel {
        private String figura = "";
        private int lado = 0;

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            if (lado <= 0) return;

            switch (figura) {
                case "cuadrado":
                    g.setColor(Color.BLUE);
                    g.fillRect(10, 10, lado, lado);
                    break;
                case "circulo":
                    g.setColor(Color.RED);
                    g.fillOval(10, 10, lado * 2, lado * 2);
                    break;
                case "triangulo":
                    g.setColor(Color.GREEN);
                    int altura = (int) (Math.sqrt(3) * lado / 2);
                    g.fillPolygon(
                        new int[]{10, 10 + lado / 2, 10 + lado},
                        new int[]{10 + altura, 10, 10 + altura},
                        3);
                    break;
            }
        }

        public void setFigura(String f) {
            this.figura = f;
            repaint();
        }

        public void setLado(int l) {
            this.lado = l;
            repaint();
        }
    }

    public String getFiguraSeleccionada() {
        return figuraSeleccionada;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        panelCalcular = new javax.swing.JPanel();
        btnCalcular = new javax.swing.JButton();
        btnNuevo = new javax.swing.JButton();
        btnSalir = new javax.swing.JButton();
        panelDatos = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        txtLado = new javax.swing.JTextField();
        jScrollPane1 = new javax.swing.JScrollPane();
        txtSalida = new javax.swing.JTextArea();
        panelSeleccionar = new javax.swing.JPanel();
        btnCuadrado = new javax.swing.JButton();
        btnCirculo = new javax.swing.JButton();
        btnTriangulo = new javax.swing.JButton();
        JPanel = new javax.swing.JPanel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        btnCalcular.setText("Calcular");

        btnNuevo.setText("Nuevo");

        btnSalir.setText("Salir");

        javax.swing.GroupLayout panelCalcularLayout = new javax.swing.GroupLayout(panelCalcular);
        panelCalcular.setLayout(panelCalcularLayout);
        panelCalcularLayout.setHorizontalGroup(
            panelCalcularLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelCalcularLayout.createSequentialGroup()
                .addContainerGap(19, Short.MAX_VALUE)
                .addGroup(panelCalcularLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(btnCalcular, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(btnNuevo, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(btnSalir, javax.swing.GroupLayout.Alignment.TRAILING))
                .addContainerGap())
        );
        panelCalcularLayout.setVerticalGroup(
            panelCalcularLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, panelCalcularLayout.createSequentialGroup()
                .addContainerGap(55, Short.MAX_VALUE)
                .addComponent(btnCalcular)
                .addGap(18, 18, 18)
                .addComponent(btnNuevo)
                .addGap(18, 18, 18)
                .addComponent(btnSalir)
                .addGap(51, 51, 51))
        );

        jLabel1.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel1.setText("Ingrese el lado:");

        txtLado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txtLadoActionPerformed(evt);
            }
        });
        txtLado.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                txtLadoKeyTyped(evt);
            }
        });

        txtSalida.setColumns(20);
        txtSalida.setRows(5);
        jScrollPane1.setViewportView(txtSalida);

        javax.swing.GroupLayout panelDatosLayout = new javax.swing.GroupLayout(panelDatos);
        panelDatos.setLayout(panelDatosLayout);
        panelDatosLayout.setHorizontalGroup(
            panelDatosLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelDatosLayout.createSequentialGroup()
                .addGroup(panelDatosLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(panelDatosLayout.createSequentialGroup()
                        .addGap(19, 19, 19)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 260, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(panelDatosLayout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel1)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, panelDatosLayout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(txtLado, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(22, 22, 22))
        );
        panelDatosLayout.setVerticalGroup(
            panelDatosLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelDatosLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addGap(15, 15, 15)
                .addComponent(txtLado, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 191, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        btnCuadrado.setText("Cuadrado");

        btnCirculo.setText("Circulo");

        btnTriangulo.setText("Triangulo");

        javax.swing.GroupLayout panelSeleccionarLayout = new javax.swing.GroupLayout(panelSeleccionar);
        panelSeleccionar.setLayout(panelSeleccionarLayout);
        panelSeleccionarLayout.setHorizontalGroup(
            panelSeleccionarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelSeleccionarLayout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addComponent(btnCuadrado)
                .addGap(18, 18, 18)
                .addComponent(btnCirculo)
                .addGap(18, 18, 18)
                .addComponent(btnTriangulo)
                .addContainerGap(33, Short.MAX_VALUE))
        );
        panelSeleccionarLayout.setVerticalGroup(
            panelSeleccionarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelSeleccionarLayout.createSequentialGroup()
                .addGap(17, 17, 17)
                .addGroup(panelSeleccionarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btnCuadrado)
                    .addComponent(btnCirculo)
                    .addComponent(btnTriangulo))
                .addContainerGap(24, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout JPanelLayout = new javax.swing.GroupLayout(JPanel);
        JPanel.setLayout(JPanelLayout);
        JPanelLayout.setHorizontalGroup(
            JPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 440, Short.MAX_VALUE)
        );
        JPanelLayout.setVerticalGroup(
            JPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 122, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(panelCalcular, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(panelDatos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(panelSeleccionar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(JPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(panelCalcular, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(panelSeleccionar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(panelDatos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(38, 38, 38)
                .addComponent(JPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void txtLadoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_txtLadoKeyTyped
        // TODO add your handling code here:
        int key = evt.getKeyChar();
        boolean numeros=key >=48 &&key<=57;
        if(!numeros){
            evt.consume();
        }
    }//GEN-LAST:event_txtLadoKeyTyped

    private void txtLadoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txtLadoActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txtLadoActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(CuadradoVista.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(CuadradoVista.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(CuadradoVista.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(CuadradoVista.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new CuadradoVista().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel JPanel;
    private javax.swing.JButton btnCalcular;
    private javax.swing.JButton btnCirculo;
    private javax.swing.JButton btnCuadrado;
    private javax.swing.JButton btnNuevo;
    private javax.swing.JButton btnSalir;
    private javax.swing.JButton btnTriangulo;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JPanel panelCalcular;
    private javax.swing.JPanel panelDatos;
    private javax.swing.JPanel panelSeleccionar;
    private javax.swing.JTextField txtLado;
    private javax.swing.JTextArea txtSalida;
    // End of variables declaration//GEN-END:variables
}
