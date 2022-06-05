extend class MinimalStatusBar {
	
	void DrawUnitBarCol(Color unit, int monitor, int monitorMax, Vector2 pos, Vector2 size, int flags = 0) {
		
		if (monitor <= 0) return;
		
		int monClamp = (monitor > monitorMax) ? monitorMax : monitor;
		
		Fill(unit, pos.x, pos.y, monClamp * size.x / monitorMax, size.y, flags);
	}
	
	void DrawUnitBarColDouble(Color unit, Color overUnit, int monitor, int monitorMax, int monitorOver, Vector2 pos, Vector2 size, int flags = 0) {
		
		if (monitor <= 0) return;
		
		int monitorMax2 = monitorMax+monitorOver;
		int monClamp = (monitor > monitorMax) ? monitorMax : monitor;
		int overmonClamp = (monitor > monitorMax2) ? monitorMax : monitor - monitorMax; // [numnzel] check parametrized values
		
		// fill the "normal" part
		Fill(unit, pos.x, pos.y, monClamp * size.x / monitorMax, size.y, flags);
		
		// fill the "over" part (for bonus health, armor)
		if (overmonClamp > 0) {
			if (overmonClamp > (monitorMax2-monitorMax)) overmonClamp = (monitorMax2-monitorMax); // [numnzel] check parametrized values overflow
			Fill(overunit, pos.x, pos.y, overmonClamp * size.x / (monitorMax2-monitorMax), size.y, flags);
		}
	}
	
	void DrawUnitBarGrad(Color uF, Color uT,
						 int monitor, int monitorMax, Vector2 pos, Vector2 size, int flags = 0, bool inverse = false) { // [numnzel] added inverse parameter
		
		Vector2 inverseSize = (inverse) ? size*-1 : size; // [numnzel] inverses the bar
		int inverseOffset = (inverse) ? size.x : 0; // [numnzel] make position corrections when the bar is inverted
		
		// get the change in color every iteration
		double uFD[4] = { 0.0, 0.0, 0.0, 0.0 };
		uFD[0] = (uF.a - uT.a) / size.y; uFD[1] = (uF.r - uT.r) / size.y;
		uFD[2] = (uF.g - uT.g) / size.y; uFD[3] = (uF.b - uT.b) / size.y;
		
		// draw bar, change color, rinse & repeat until done
		Color drawCol = "000000";
		int cC[4] = { 0, 0, 0, 0 };
		
		for (int y = 0; y < size.y; y++) {
			drawCol = Color(uF.a + cC[0], uF.r + cC[1], uF.g + cC[2], uF.b + cC[3]);
			DrawUnitBarCol(drawCol, monitor, monitorMax, (pos.x+inverseOffset, pos.y + y), (inverseSize.x, 1), flags);
			cC[0] -= uFD[0]; cC[1] -= uFD[1]; cC[2] -= uFD[2]; cC[3] -= uFD[3];
		}
	}
	
	void DrawUnitBarGradDouble(Color uF, Color uT, Color ovuF, Color ovuT,
						 int monitor, int monitorMax, int monitorOver, Vector2 pos, Vector2 size, int flags = 0, bool inverse = false) { // [numnzel] added inverse parameter
		
		Vector2 inverseSize = (inverse) ? size*-1 : size; // [numnzel] inverses the bar
		int inverseOffset = (inverse) ? size.x : 0; // [numnzel] make position corrections when the bar is inverted
		
		// get the change in color every iteration
		double uFD[4] = { 0.0, 0.0, 0.0, 0.0 };
		uFD[0] = (uF.a - uT.a) / size.y; uFD[1] = (uF.r - uT.r) / size.y;
		uFD[2] = (uF.g - uT.g) / size.y; uFD[3] = (uF.b - uT.b) / size.y;
		double ovuFD[4] = { 0.0, 0.0, 0.0, 0.0 };
		ovuFD[0] = (ovuF.a - ovuT.a) / size.y; ovuFD[1] = (ovuF.r - ovuT.r) / size.y;
		ovuFD[2] = (ovuF.g - ovuT.g) / size.y; ovuFD[3] = (ovuF.b - ovuT.b) / size.y;
		
		// draw bar, change color, rinse & repeat until done
		Color drawCol = "000000";
		Color overDrawCol = "000000";
		int cC[4] = { 0, 0, 0, 0 };
		int ovcC[4] = { 0, 0, 0, 0 };
		for (int y = 0; y < size.y; y++) {
			drawCol = Color(uF.a + cC[0], uF.r + cC[1], uF.g + cC[2], uF.b + cC[3]);
			overDrawCol = Color(ovuF.a + ovcC[0], ovuF.r + ovcC[1], ovuF.g + ovcC[2], ovuF.b + ovcC[3]);
			DrawUnitBarColDouble(drawCol, overDrawCol, monitor, monitorMax, monitorOver, (pos.x+inverseOffset, pos.y + y), (inverseSize.x, 1), flags);
			cC[0] -= uFD[0]; cC[1] -= uFD[1]; cC[2] -= uFD[2]; cC[3] -= uFD[3];
			ovcC[0] -= ovuFD[0]; ovcC[1] -= ovuFD[1]; ovcC[2] -= ovuFD[2]; ovcC[3] -= ovuFD[3];
		}
	}
	
	// draw the edges of a "hud box"
	Vector2, Vector2, Vector2, Vector2 DrawHUDBoxEdges(String corner, String edge, Vector2 pos, Vector2 size, int flags = 0, double alpha = 1) {
		// corners are ezpz
		DrawImage(corner.."TL", pos, DI_ITEM_LEFT_TOP | flags, alpha);
		DrawImage(corner.."TR", (pos.x + size.x, pos.y), DI_ITEM_RIGHT_TOP | flags, alpha);
		DrawImage(corner.."BL", (pos.x, pos.y + size.y), DI_ITEM_LEFT_BOTTOM | flags, alpha);
		DrawImage(corner.."BR", pos + size, DI_ITEM_RIGHT_BOTTOM | flags, alpha);
		
		// store the sizes of all the corners so we know where to draw the edges
		Vector2 tlCornerSize = TexSize(corner.."TL");
		Vector2 trCornerSize = TexSize(corner.."TR");
		Vector2 blCornerSize = TexSize(corner.."BL");
		Vector2 brCornerSize = TexSize(corner.."BR");
		
		// the edges are drawn as one image, just scaled on the x/y axis
		DrawImage(edge.."T", (pos.x + tlCornerSize.x, pos.y), DI_ITEM_LEFT_TOP | flags,
				  alpha, (-1, -1), (size.x - (tlCornerSize.x + trCornerSize.x), 1));
		DrawImage(edge.."B", (pos.x + blCornerSize.x, pos.y + size.y), DI_ITEM_LEFT_BOTTOM | flags,
				  alpha, (-1, -1), (size.x - (blCornerSize.x + brCornerSize.x), 1));
		
		DrawImage(edge.."L", (pos.x, pos.y + tlCornerSize.y), DI_ITEM_LEFT_TOP | flags,
				  alpha, (-1, -1), (1, size.y - (tlCornerSize.y + blCornerSize.y)));
		DrawImage(edge.."R", (pos.x + size.x, pos.y + blCornerSize.y), DI_ITEM_RIGHT_TOP | flags,
				  alpha, (-1, -1), (1, size.y - (trCornerSize.y + brCornerSize.y)));
		
		return tlCornerSize, trCornerSize, blCornerSize, brCornerSize;
	}
	
	void DrawHudBoxCol(String corner, String edge, Color fillColor, Vector2 pos, Vector2 size, int flags = 0, double alpha = 1) {
		// get the corner sizes
		Vector2 tlCornerSize, trCornerSize, blCornerSize, brCornerSize;
		[tlCornerSize, trCornerSize, blCornerSize, brCornerSize] = DrawHudBoxEdges(corner, edge, pos, size, flags, alpha);
		
		// fill in the inside
		fillColor = Color(int(alpha * fillColor.a), fillColor.r, fillColor.g, fillColor.b);
		Fill(fillColor, pos.x + tlCornerSize.x, pos.y + tlCornerSize.y,
			 size.x - (tlCornerSize.x + trCornerSize.x), size.y - (tlCornerSize.y + blCornerSize.y), flags);
	}
	
	void DrawMainBar(double TicFrac) {}
	
	// TODO: vector2 box after vector2 scale; imageH and imageW as vector2; posX and posY as vector2; generate DrawClipImage, same but without bar capabilities (remove setcliprect);
	void DrawImageBar(string image, int imageH, int imageW, int posX, int posY, int flags = 0, double alpha = 1.0, Vector2 box = (-1,-1), Vector2 scale = (1.0,1.0)) {
		
		// check that scale is not 0....
		
		int imageWidthEnd = imageW / round(1.0/scale.x);
		int imageHeightEnd = imageH / round(1.0/scale.y);
		
		if (flags == 0) {
			SetClipRect(posX+(-imageWidthEnd/2), posY-imageHeightEnd, imageWidthEnd, imageHeightEnd, DI_SCREEN_CENTER_BOTTOM);
			DrawImage(image, (posX, posY), DI_SCREEN_CENTER_BOTTOM, alpha, box, scale);
		}
		else {
			SetClipRect(posX+(-imageWidthEnd/2), posY-imageHeightEnd, imageWidthEnd, imageHeightEnd, flags);
			DrawImage(image, (posX, posY), flags, alpha, box, scale);
		}
		
		ClearClipRect();
	}

	string GetCustomMugshot(Actor who) {
		
		string result = "FACEA01";

		if (who.FindInventory("playerleft2"))
			result = "FACEB02";
		else if (who.FindInventory("playerleft1"))
			result = "FACEB01";
		else if (who.FindInventory("playerright2"))
			result = "FACEC02";
		else if (who.FindInventory("playerright1"))
			result = "FACEC01";
		else if (who.FindInventory("playeranim2"))
			result = "FACEA03";
		else if (who.FindInventory("playeranim1"))
			result = "FACEA02";
		else if (who.FindInventory("playerspell"))
			result = "FACES00";
		else if (who.FindInventory("playerpain"))
			result = "FACEP00";
		else if (who.FindInventory("playerdied"))
			result = "FACED00";

		return result;
	}
}
