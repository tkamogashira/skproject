/*
 * This file is part of JAMAL.
 *
 * JAMAL is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2, as published
 * by the Free Software Foundation.
 *
 * JAMAL is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with JAMAL; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package com.jamal.client;

import com.jamal.MatlabCaller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

/**
 * @version 1.0 13-Apr-2010 19:09:41
 * @author: Hut
 */
public class Jamal extends JPanel {
    private static final long serialVersionUID = 1L;

    private JTextField hostTextField;

    private JButton stopServerJButton;

    public Jamal() {

        hostTextField = new JTextField(MatlabCaller.HOST_ADDRESS);

        stopServerJButton = new JButton("Stop Matlab Server");
        stopServerJButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                stopMatlabServer(hostTextField.getText());
            }
        });


        setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));

        Box box = new Box(BoxLayout.LINE_AXIS);
        box.add(new JLabel("Host "));
        box.add(hostTextField);
        add(box);


        add(stopServerJButton);

    }

    private static void stopMatlabServer(String host) {
        try {
            MatlabClient matlabClient = new MatlabClient(host);
            matlabClient.shutDownServer();
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }


    //<-------------------Methods to launch GUI----------------------->

    public static void createAndShowGUI() {
        JFrame frame = new JFrame("Jamal GUI client");

        //Setting up windows look and feel

        frame.setContentPane(new Jamal());
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.pack();
        frame.setVisible(true);

    }

    public static void main(String[] args) {
        String host = null;
        try {
            if (args.length == 0) {
                //Schedule a job for the event-dispatching thread:
                //creating and showing this application's GUI.
                SwingUtilities.invokeLater(new Runnable() {
                    @Override
                    public void run() {
                        createAndShowGUI();
                    }
                });
            }
            for (int i = 0; i < args.length; i++) {
                if ((args[i].length() == 2) && (args[i].charAt(0) == '-')) {
                    switch (args[i].charAt(1)) {
                        case 'h':
                            host = args[++i];
                            break;
                    }
                }
            }
        } catch (NumberFormatException e) {
            printOutHelp();
        }
        if (host != null) {
            stopMatlabServer(host);
        } else {
            printOutHelp();
        }

    }

    private static void printOutHelp() {
        System.out.println("Usage: java -jar JAMAL.jar -h <host>");
        System.out.println("\tStops launched MatlabServer.");
        System.out.println("\t\t<host> Matlab server host");
        System.out.println("\n");
        System.out.println("Usage: java -jar JAMAL.jar ");
        System.out.println("\tLaunches GUI version.");


    }


}
