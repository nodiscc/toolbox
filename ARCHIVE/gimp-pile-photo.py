#!/usr/bin/env python
#Description: gimp-fu script to generate a photo collage
# -*- coding: utf8 -*-

# *************************************************************************** #
#                                                                             #
#      Version 0.1 - 2010-11-05                                               #
#      Copyright (C) 2010 Marco Crippa                                        #
#                                                                             #
#      This program is free software; you can redistribute it and/or          #
#      modify it under the terms of the GNU General Public License            #
#      as published by the Free Software Foundation; either version 2         #
#      of the License, or (at your option) any later version.                 #
#                                                                             #
#      This program is distributed in the hope that it will be useful,        #
#      but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          #
#      GNU General Public License for more details.                           #
#                                                                             #
#      You should have received a copy of the GNU General Public License      #
#      along with this program; if not, write to the                          #
#      Free Software Foundation, Inc.,                                        #
#      51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA           #
#                                                                             #
# *************************************************************************** #

from gimpfu import *
import math,random


def photos( img, draw, rows, columns, rotation, dim_border, col_border, shadow, col_shadow, off_x, off_y, shadow_alpha, shadow_blur, col_bkg, h_range, l_range, s_range):
	
	photo_w=pdb.gimp_image_width(img)/columns
	photo_h=pdb.gimp_image_height(img)/rows

	current_f=pdb.gimp_context_get_foreground()
	current_b=pdb.gimp_context_get_background()
	#border color
	pdb.gimp_context_set_foreground(col_border)
	#shadow color
	pdb.gimp_context_set_background(col_shadow)

	pdb.gimp_image_resize(img,pdb.gimp_image_width(img)+(dim_border*4),pdb.gimp_image_height(img)+(dim_border*4),dim_border*2,dim_border*2)

	pos_x=0+(dim_border*2)
	pos_y=0+(dim_border*2)
	
	img.disable_undo()

	for a in reversed(xrange(0,int(columns))):

		pdb.gimp_image_set_active_layer(img,draw)

		pos_x=pos_x+(photo_w*a)

		for i in reversed(xrange(0,int(rows))):
		
			pos_y=pos_y+(photo_h*i)
		
			#make selection photo
			pdb.gimp_rect_select(img, pos_x, pos_y, photo_w, photo_h, 0, False, 0)

			#copy selection photo
			pdb.gimp_edit_copy(draw)
			f_sel=pdb.gimp_edit_paste(draw,True)
			pdb.gimp_floating_sel_to_layer(f_sel)
			pdb.gimp_layer_resize(f_sel,photo_w+(dim_border*2),photo_h+(dim_border*2),dim_border,dim_border)
			
			#change HLS
			if h_range!=0 or l_range!=0 or s_range!=0:
				h_offset=float(random.randint( 0-h_range, h_range))
				l_offset=float(random.randint( 0-l_range, l_range))
				s_offset=float(random.randint( 0-s_range, s_range))
				pdb.gimp_hue_saturation(f_sel,0,h_offset,l_offset,s_offset)

			#make border
			if dim_border!=0:
				pdb.gimp_rect_select(img, pos_x-dim_border, pos_y-dim_border, photo_w+(dim_border*2), photo_h+(dim_border*2), 0, False, 0)
				pdb.gimp_rect_select(img, pos_x, pos_y, photo_w, photo_h, 1, False, 0)
				pdb.gimp_edit_fill(f_sel,0)

			pdb.gimp_selection_clear(img)
			#shadow
			if shadow==1:
				pdb.script_fu_drop_shadow(img, f_sel, off_x, off_y, shadow_blur, col_shadow, shadow_alpha, 0)
				#merge layer
				f_sel=pdb.gimp_image_merge_down(img, f_sel, 0)
	
			#autocrop layer
			pdb.plug_in_autocrop_layer(img, f_sel)
			name_photo="photo_"+str(a)+"_"+str(i)
			pdb.gimp_drawable_set_name(f_sel,name_photo)
	
			if rotation!=0:
				ang=random.randint( 0-rotation, rotation)
				pdb.gimp_drawable_transform_rotate_default(f_sel, math.radians(ang), True, 0, 0, True, 0)

			pos_y=0+(dim_border*2)

		pos_x=0+(dim_border*2)

	pdb.gimp_image_resize_to_layers(img)

	#make background
	bkg_l=pdb.gimp_layer_new(img,pdb.gimp_image_width(img),pdb.gimp_image_height(img),0,"Bkg_composition",100,0)
	num_l,list_l = pdb.gimp_image_get_layers(img)
	pdb.gimp_image_add_layer(img,bkg_l,num_l-1)
	pdb.gimp_context_set_foreground(col_bkg)
	pdb.gimp_edit_fill(bkg_l,0)

	img.enable_undo()

	pdb.gimp_context_set_foreground(current_f)
	pdb.gimp_context_set_background(current_b)


register( "pile_photos",
  "Pile's Photos",
  "Make one photo look like a pile of photos",
  "Marco Crippa",
  "(©) 2010 Marco Crippa",
  "2010-11-05",
  "<Image>/Filters/Decor/Pile's Photos",
  'RGB*',
  [ 
		(PF_SPINNER, "rows", "Numbers of rows:", 2, (1, 9999999999, 1)),
		(PF_SPINNER, "columns", "Numbers of column:", 2, (1, 9999999999, 1)),
		(PF_SPINNER, "rotation", "Rotation +/-:", 5, (0, 180, 1)),

		(PF_SPINNER, "dim_border", "Border :", 5, (0, 9999999999, 1)),
		(PF_COLOR, "col_border", "Border color:", (255,255,255)),

		(PF_BOOL,"shadow", "Shadow:", 1),
		(PF_COLOR, "col_shadow", "Shadow color:", (0,0,0)),
		(PF_SPINNER, "off_x", "Shadow offset x:", 5, (0, 4096, 1)),
		(PF_SPINNER, "off_y", "Shadow offset y:", 5, (0, 4096, 1)),
		(PF_SPINNER, "shadow_alpha", "Shadow alpha:", 90, (0, 100, 1)),
		(PF_SPINNER, "shadow_blur", "Shadow blur radius:", 15, (0, 1024, 1)),

		(PF_COLOR, "col_bkg", "Background color:", (255,255,255)),

		(PF_SPINNER, "h_range", "Hue random +/-:", 0, (0, 180, 1)),
		(PF_SPINNER, "l_range", "Lightness random +/-:", 0, (0, 100, 1)),
		(PF_SPINNER, "s_range", "Saturation random +/-:", 0, (0, 100, 1))
  ],
  '',
  photos)

main()

