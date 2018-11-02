Shader "Custom/GrassTerrainShader" {
	Properties {
		_Color("Color", Color) = (0, 1, 0, 1)
		_MainTex("Grass Texture", 2D) = "white" {}
		_Cutoff("Cutoff", Range(0, 1)) = 0.87
		_GrassHeight("Grass Height", Float) = 1.2
		_GrassWidth("Grass Width", Float) = 1
		_WindSpeed("Wind Speed", Float) =40
		_WindStrength("Wind Strength", Float) = 0.02
	}
	
	SubShader {
		Tags {
			"Queue" = "AlphaTest"
			//"IgnoreProjector" = "True"
			//"RenderType" = "TransparentCutout"
		}
		LOD 200

		pass{

		CULL OFF

		CGPROGRAM
		#include "UnityCG.cginc" 
		#pragma vertex vert
		#pragma fragment frag
		#pragma geometry geom

		// Use shader model 4.0 target, we need geometry shader support
		#pragma target 4.0

		sampler2D _MainTex; 
		sampler2D _DeformMap;

		struct v2g {
			float4 pos:SV_POSITION; 
			float3 norm:NORMAL; 
			float2 uv:TEXCOORD0; 
			float3 color:TEXCOORD1; 
		}; 

		struct g2f {
			float4 pos:SV_POSITION; 
			float3 norm:NORMAL; 
			float2 uv:TEXCOORD0; 
			float3 color:TEXCOORD1; 
		}; 

		fixed4 _Color; 
		half _GrassHeight; 
		half _GrassWidth; 
		half _Cutoff; 
		half _WindStrength; 
		half _WindSpeed; 

		v2g vert(appdata_full v) {
			float3 centreBtm = v.vertex.xyz; 

			v2g OUT; 
			OUT.pos = v.vertex; 
			OUT.norm = v.normal; 
			OUT.uv = v.texcoord; 
			OUT.color = tex2Dlod(_MainTex, v.texcoord).rgb; 
			return OUT; 
		}

		void quadCreator(inout TriangleStream<g2f> triStream, float3 points[4], float3 color){
			g2f OUT;
			float3 faceNormal = cross(points[1] - points[0], points[2] - points[0]);
			for(uint i = 0; i < 4 ; i++){
				OUT.pos = UnityObjectToClipPos(points[i]);
				OUT.norm = faceNormal;
				OUT.color = color;
				OUT.uv = float2(i % 2, i/2);
				triStream.Append(OUT);
			}
			triStream.RestartStrip();
		}

		[maxvertexcount(12)]
		void geom(point v2g IN[1], inout TriangleStream<g2f> triStream) {
			float3 lightPosition = _WorldSpaceLightPos0; 

			float3 perpendicularAngle = float3(1, 0, 0); 
			float3 faceNormal = cross(perpendicularAngle, IN[0].norm); 

			float3 centreBtm = IN[0].pos.xyz; 
			float3 centreTop = centreBtm + IN[0].norm * _GrassHeight; 

			float3 wind = float3(
				sin(_Time.x * _WindSpeed + centreBtm.x),
				0,
				cos(_Time.x * _WindSpeed + centreBtm.z)
			); 

			centreTop += wind * _WindStrength; 

			float3 color = (IN[0].color); 

			fixed sin60 = 0.866f; //cos30
			fixed cos60 = .5f;//sin30 

			float3 quad1[4] = {
				centreBtm + perpendicularAngle * .5 * _GrassWidth,
				centreBtm - perpendicularAngle * .5 * _GrassWidth,
				centreTop + perpendicularAngle * .5 * _GrassWidth,
				centreTop - perpendicularAngle * .5 * _GrassWidth
			};
			quadCreator(triStream, quad1, color);

			float3 quad2[4] = {
				centreBtm + float3(-cos60, 0, sin60) * .5 * _GrassWidth,
				centreBtm - float3(-cos60, 0, sin60) * .5 * _GrassWidth,
				centreTop + float3(-cos60, 0, sin60) * .5 * _GrassWidth,
				centreTop - float3(-cos60, 0, sin60) * .5 * _GrassWidth
			};
			quadCreator(triStream, quad2, color);

			float3 quad3[4] = {
				centreBtm + float3(cos60, 0, sin60) * .5 * _GrassWidth,
				centreBtm - float3(cos60, 0, sin60) * .5 * _GrassWidth,
				centreTop + float3(cos60, 0, sin60) * .5 * _GrassWidth,
				centreTop - float3(cos60, 0, sin60) * .5 * _GrassWidth
			};
			quadCreator(triStream, quad3, color);
		}

		half4 frag(g2f IN):COLOR {
			fixed4 c = tex2D(_MainTex, IN.uv) * _Color; 
			clip(c.a - _Cutoff); 
			return c;
		}

		ENDCG

		}
	}
}