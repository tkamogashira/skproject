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

package com.jamal.server;


import java.net.URL;
import java.rmi.RMISecurityManager;
import com.jamal.MatlabCaller;
import com.jamal.MatlabFunction;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import static com.jamal.MatlabCaller.JAMAL_PREFIX;

/**
 * @version 1.0 Jan 17, 2010 2:47:47 PM
 * @author: Hut
 */
public class MatlabServer {


    /**
     * Matlab function to be executed
     */
    private static MatlabFunction matlabFunction;


    /**
     * Flag that indicates execution process
     */
    private static boolean startFunctionExecution;


    private static boolean running;

    /**
     * Default constructor
     */
    public MatlabServer() {

        startRMIRegistry();

        try {
            MatlabCaller matlabCaller = new MatlabCallerImpl();
            Naming.rebind(String.format("rmi://%s:%d/%s", MatlabCaller.HOST_ADDRESS,
                    Registry.REGISTRY_PORT, MatlabCaller.SERVICE_NAME), matlabCaller);
            System.out.println(String.format("%sMatlabServer is ready", JAMAL_PREFIX));
            startWaitingForCommand();
            Naming.unbind(String.format("rmi://%s:%d/%s", MatlabCaller.HOST_ADDRESS,
                    Registry.REGISTRY_PORT, MatlabCaller.SERVICE_NAME));

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (RemoteException e) {
            e.printStackTrace();
        } catch (NotBoundException e) {
            e.printStackTrace();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (Exception e1) {
            System.out.println(String.format("%sTrouble: ", JAMAL_PREFIX));
            e1.printStackTrace();
        }
    }


    /**
     * Starts RMI registry. It is necessary to receive RMI calls.
     */

    private void startRMIRegistry() {
        Registry registry;

        URL url = getClass().getResource("/jamalResources/client.policy");

        System.setProperty("java.security.policy", url.toString());
        if (System.getSecurityManager() == null) {
            System.setSecurityManager(new RMISecurityManager());
        }
        
        try {
            registry = LocateRegistry.getRegistry(MatlabCaller.HOST_ADDRESS,
                    Registry.REGISTRY_PORT);
            registry.list();
        } catch (RemoteException e) {
            try {
                LocateRegistry.createRegistry(Registry.REGISTRY_PORT);
            } catch (Exception e1) {
                System.out.println(String.format("%sProblem starting RMI registry:",
                        JAMAL_PREFIX));
                e.printStackTrace();
            }
        }

    }


    /**
     * Infinite loop that waits for a command to be executed and executes it.
     *
     * @throws InterruptedException thrown exception
     */

    private void startWaitingForCommand() throws InterruptedException {
        running = true;
        while (running) {
            if (startFunctionExecution) {
                processFunction();
            }
            Thread.sleep(30);
        }
    }

    private void processFunction() {
        if (matlabFunction.getFunctionName().equals(MatlabFunction.QUIT)) {
            System.out.println(String.format("%sShutting down server...", JAMAL_PREFIX));
            running = false;
            startFunctionExecution = false;
            return;
        }

        //System.out.println(String.format("%sCalling Matlab function \"%s\" from java", JAMAL_PREFIX, matlabFunction.getFunctionName()));
        Object output = null;
        Exception matlabExecutionException = null;
        try {
            output = com.mathworks.jmi.Matlab.mtFevalConsoleOutput(
                    matlabFunction.getFunctionName(), matlabFunction.getInputArgs(),
                    matlabFunction.getNumberOfOutputArguments());
        } catch (Exception e) {
            //System.out.println(String.format("%sJava Exception thrown", JAMAL_PREFIX));
            e.printStackTrace();
            matlabExecutionException = e;
        } finally {
            //System.out.println(String.format("%sEnd Calling Matlab function \"%s\"", JAMAL_PREFIX, matlabFunction.getFunctionName()));
        }

        if (matlabExecutionException != null) {
            matlabFunction.setOutputData(new Object[]{matlabExecutionException});
        } else {

            if (matlabFunction.getNumberOfOutputArguments() <= 1) {
                matlabFunction.setOutputData(new Object[]{output});
            } else {
                matlabFunction.setOutputData((Object[]) output);
            }

        }

        startFunctionExecution = false;
    }


    public static void main(String args[]) {
        new MatlabServer();
    }

    public static MatlabFunction getMatlabFunction() {
        return matlabFunction;
    }

    public static void setMatlabFunction(MatlabFunction matlabFunction) {
        MatlabServer.matlabFunction = matlabFunction;
    }

    public static boolean isStartFunctionExecution() {
        return startFunctionExecution;
    }


    public static void setStartFunctionExecution() {
        MatlabServer.startFunctionExecution = true;
    }
}


