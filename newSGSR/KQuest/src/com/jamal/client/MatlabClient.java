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

import com.jamal.JamalException;
import com.jamal.MatlabCaller;
import com.jamal.MatlabFunction;

import java.io.IOException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.Registry;

import static com.jamal.MatlabCaller.JAMAL_PREFIX;

/**
 * Client for calling Matlab functions from a Java program
 *
 * @version 1.0 Jan 17, 2010 3:03:17 PM
 * @author: Hut
 */
public class MatlabClient {

    private MatlabCaller matlabCaller;

    /**
     * MatlabClient constructor.
     * MatlabServer host is taken from <code>MatlabCaller.HOST_ADDRESS</code>.
     *
     * @throws com.jamal.JamalException
     */
    public MatlabClient() throws JamalException {
        this(MatlabCaller.HOST_ADDRESS, MatlabCaller.MATLAB_EXECUTABLE_PATH);
    }

    public MatlabClient(String host) throws JamalException {
        this(host, MatlabCaller.MATLAB_EXECUTABLE_PATH);
    }

    /**
     * MatlabClient constructor.
     * MatlabServer host is passed as input parameter.
     *
     * @param host Host with MatlabServer
     * @throws JamalException
     */
    public MatlabClient(String host, String matlabExecutablePath, int timeOut) throws JamalException {
        try {
            matlabCaller = (MatlabCaller) Naming.lookup(String.format("rmi://%s:%d/%s", host, Registry.REGISTRY_PORT, MatlabCaller.SERVICE_NAME));
        } catch (Exception e) {
            boolean successfllyConnected = false;
            if (host.equalsIgnoreCase("localhost") || host.equals("127.0.0.1")) {
                try {
                    System.out.println(String.format("%sMatlab host %s seems to be dead. Trying to launch MatlabServer on the localhost...", JAMAL_PREFIX, host));
                    Runtime rt = Runtime.getRuntime();
                    String command = String.format("%s -automation -nosplash -nodesktop -r \"com.jamal.server.MatlabServer;quit;\"", matlabExecutablePath);
                    rt.exec(command);
                    //Now wait until Matlab starts
                    for (int i = 0; i < timeOut; i++) {
                        try {
                            Thread.sleep(1000);
                            matlabCaller = (MatlabCaller) Naming.lookup(String.format("rmi://%s:%d/%s", host, Registry.REGISTRY_PORT, MatlabCaller.SERVICE_NAME));
                            successfllyConnected = true;
                            break;
                        } catch (Exception e1) {
                            System.out.println(String.format("%sTrying to connect to MatlabServer... %d", JAMAL_PREFIX, i));
                        }
                    }
                } catch (IOException e1) {
                    throw new JamalException(String.format("%sMatlab host %s seems to be dead", JAMAL_PREFIX, host), e);
                }
            }
            if (successfllyConnected) {
                System.out.println(String.format("%sSuccessfully connected to MatlabServer!", JAMAL_PREFIX));
            } else {
                throw new JamalException(String.format("%sCould not connect to MatlabServer on host %s", JAMAL_PREFIX, host), e);
            }
        }
    }

    public MatlabClient(String host, String matlabExecutablePath) throws JamalException {
        this(host, matlabExecutablePath, MatlabCaller.TIME_OUT);
    }


    /**
     * Executes Matlab function and returns an array of output arguments
     *
     * @param matlabFunctionName Matlab function name
     * @param inputArgs          Array of input arguments
     * @param numberOfOutputArgs Number of output arguments
     * @return output arguments as array of Object
     * @throws com.jamal.JamalException JamalException
     */
    public Object[] executeMatlabFunction(String matlabFunctionName, Object[] inputArgs, int numberOfOutputArgs) throws JamalException {

        Object[] output;
        try {
            output = matlabCaller.executeMatlabFunction(matlabFunctionName, inputArgs, numberOfOutputArgs);
            if (output != null && output.length > 0 && output[0] instanceof Exception) {
                System.out.println(String.format("%s%s", JAMAL_PREFIX, ((Exception) output[0]).getLocalizedMessage()));
                output = new Object[0];
                throw new JamalException("Matlab has thrown an exception ", (Exception) output[0]);
            }

        } catch (RemoteException e) {
            throw new JamalException(String.format("%sError occured while executing Matlab function %s", JAMAL_PREFIX, matlabFunctionName), e);
        }
        return output;
    }

    /**
     * Shuts down MatlabServer
     *
     * @throws JamalException exception thrown
     */
    public void shutDownServer() throws JamalException {
        executeMatlabFunction(MatlabFunction.QUIT, null, 0);
    }

}
