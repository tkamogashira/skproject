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
 * @version 1.0 Jan 17, 2010 4:42:54 PM
 * @author: Hut
 */
public class MatlabFunction {

    public static final String QUIT = "quit";

    private String functionName;

    private Object[] inputArgs;

    private int numberOfOutputArguments;

    private Object[] outputData;

    public MatlabFunction(String functionName, Object[] inputArgs, int numberOfOutputArguments) {
        this.functionName = functionName;
        this.inputArgs = inputArgs;
        this.numberOfOutputArguments = numberOfOutputArguments;
    }

    public String getFunctionName() {
        return functionName;
    }

    public Object[] getInputArgs() {
        return inputArgs;
    }

    public int getNumberOfOutputArguments() {
        return numberOfOutputArguments;
    }

    public Object[] getOutputData() {
        return outputData;
    }

    public void setOutputData(Object[] outputData) {
        this.outputData = outputData;
    }
}
