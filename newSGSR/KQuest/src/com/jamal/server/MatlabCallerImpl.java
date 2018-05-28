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


import com.jamal.MatlabCaller;
import com.jamal.MatlabFunction;

import java.rmi.RemoteException;

/**
 * Implementation of Matlab caller
 *
 * @version 1.0 Jan 17, 2010 2:44:17 PM
 * @author: Hut
 */
public class MatlabCallerImpl extends java.rmi.server.UnicastRemoteObject implements MatlabCaller {
    private static final long serialVersionUID = 1L;

    /**
     * Default constructor
     *
     * @throws java.rmi.RemoteException
     */
    public MatlabCallerImpl() throws java.rmi.RemoteException {
        super();
    }

    /**
     * Since Matlab does not allow execution functions in java threads different from the main one, it is necessary
     * to pass com.jamal.MatlabFunction object to com.jamal.server.MatlabServer, where it is executed
     *
     * @param functionName       functionName
     * @param inputArgs          inputArgs
     * @param numberOfOutputArgs numberOfOutputArgs
     * @return Output arguments
     * @throws RemoteException thrown exception
     */
    public synchronized Object[] executeMatlabFunction(String functionName, Object[] inputArgs, int numberOfOutputArgs) throws RemoteException {
        MatlabFunction matlabFunction = new MatlabFunction(functionName, inputArgs, numberOfOutputArgs);

        MatlabServer.setMatlabFunction(matlabFunction);
        MatlabServer.setStartFunctionExecution();

        while (MatlabServer.isStartFunctionExecution()) {
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
            }
        }
        return MatlabServer.getMatlabFunction().getOutputData();
    }

}