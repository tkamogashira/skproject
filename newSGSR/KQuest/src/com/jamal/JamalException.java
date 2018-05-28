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
 * @version 1.0 18-Apr-2010 00:14:13
 * @author: Hut
 */
public class JamalException extends Exception {
    private static final long serialVersionUID = 1L;

    /**
     * Constructs an instance of <code>JamalException</code> with the specified detail message.
     *
     * @param msg the detail message.
     */
    public JamalException(String msg) {
        super(msg);
    }

    /**
     * Constructs an instance of <code>JamalException</code> with the specified detail message and the nested exception.
     *
     * @param msg the detail message.
     * @param ex  The original exception
     */
    public JamalException(String msg, Exception ex) {
        super(msg, ex);
    }

}
