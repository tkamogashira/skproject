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

package com.jamal;

/**
 * Remote interface to Matlab
 *
 * @version 1.0 Jan 17, 2010 2:41:41 PM
 * @author: Hut
 */
public interface MatlabCaller extends java.rmi.Remote {

    /**
     * Host address with installed Matlab
     */
    final String HOST_ADDRESS = "localhost";

    /**
     * Executable path of Matlab
     */
    final String MATLAB_EXECUTABLE_PATH = "c:/MATLAB/R2009b/bin/matlab.exe";

    final int TIME_OUT = 10;


    /**
     * Log messages prefix
     */
    final String JAMAL_PREFIX = "Jamal::";

    /**
     * RMI service name
     */
    final String SERVICE_NAME = "MatlabCallerService";

    Object[] executeMatlabFunction(String matlabFunctionName, Object[] inputArgs, int numberOfOutputArgs) throws java.rmi.RemoteException;

}
