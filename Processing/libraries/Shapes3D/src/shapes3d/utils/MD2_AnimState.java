/*
 * Copyright (c) 2020 Peter Lager
 * <quark(a)lagers.org.uk> http:www.lagers.org.uk
 * 
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it freely,
 * subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented;
 * you must not claim that you wrote the original software.
 * If you use this software in a product, an acknowledgment in the product
 * documentation would be appreciated but is not required.
 * 
 * 2. Altered source versions must be plainly marked as such,
 * and must not be misrepresented as being the original software.
 * 
 * 3. This notice may not be removed or altered from any source distribution.
 */

package shapes3d.utils;

/**
 * Simple class to store that details of an animation sequence
 * in the model.
 * 
 * @author Peter Lager
 *
 */
public class MD2_AnimState {

	public String name;
	public int startframe;
	public int endFrame;

	/**
	 * Create an animation state.
	 * 
	 * @param name user defined name for this state
	 * @param startframe the start frame number
	 * @param endFrame the end frame number
	 */
	public MD2_AnimState(String name, int startframe, int endFrame) {
		super();
		this.name = name;
		this.startframe = startframe;
		this.endFrame = endFrame;
	}


	public String toString(){
		return "ANIM STATE '" + name + "' (" + startframe+ " - " + endFrame+ ")";
	}
}
