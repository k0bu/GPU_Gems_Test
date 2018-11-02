Shader "Custom/GrassGeometry" {
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
		}
		LOD 200

		pass{

		CULL OFF

		CGPROGRAM 
		#pragma vertex vert
		#pragma fragment frag
		#pragma geometry geom

		//Geometry Shaderを用いると暗に4.0に
		#pragma target 4.0

		sampler2D _MainTex; 

		struct appdata {
			float4 vertex : POSITION;
			float4 normal : NORMAL;
		};

		struct v2g {
			float4 pos:SV_POSITION; 
			float3 normal:NORMAL; 
		}; 

		struct g2f {
			float4 pos:SV_POSITION; 
			float2 uv:TEXCOORD0; 
		}; 

		fixed4 _Color; 
		half _GrassHeight; 
		half _GrassWidth; 
		half _Cutoff; 
		half _WindStrength; 
		half _WindSpeed; 

		v2g vert(appdata v) {
			float3 centreBtm = v.vertex.xyz; 

			v2g OUT; 
			OUT.pos = v.vertex; 
			OUT.normal = v.normal; 
			return OUT; 
		}

		[maxvertexcount(12)]
		void geom(point v2g IN[1], inout TriangleStream<g2f> triStream) {
			float3 centreBtm = IN[0].pos.xyz; 
			float3 centreTop = centreBtm + IN[0].normal * _GrassHeight; 

			float3 wind = float3(
				sin(_Time.x * _WindSpeed + centreBtm.x),
				0,
				cos(_Time.x * _WindSpeed + centreBtm.z)
			); 

			centreTop += wind * _WindStrength; 

			float3 initialEdgeDir = float3(1, 0, 0); 
			fixed sin60 = .866f; //cos30
			fixed cos60 = .5f;//sin30 

			g2f OUT;
			
			//quad1
			OUT.pos = UnityObjectToClipPos(
				centreBtm - 
				initialEdgeDir * .5 * _GrassWidth);
			OUT.uv = float2(0,0);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreBtm + 
				initialEdgeDir * .5 * _GrassWidth);
			OUT.uv = float2(1,0);
			triStream.Append(OUT);
			
			OUT.pos = UnityObjectToClipPos(
				centreTop - 
				initialEdgeDir * .5 * _GrassWidth);
			OUT.uv = float2(0,1);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreTop + 
				initialEdgeDir * .5 * _GrassWidth);
			OUT.uv = float2(1,1);
			triStream.Append(OUT);

			triStream.RestartStrip();

			//quad2
			OUT.pos = UnityObjectToClipPos(
				centreBtm - 
				float3(-cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(0,0);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreBtm + 
				float3(-cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(1,0);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreTop - 
				float3(-cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(0,1);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreTop + 
				float3(-cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(1,1);
			triStream.Append(OUT);

			triStream.RestartStrip();

			//quad2
			OUT.pos = UnityObjectToClipPos(
				centreBtm - 
				float3(cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(0,0);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreBtm + 
				float3(cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(1,0);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreTop - 
				float3(cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(0,1);
			triStream.Append(OUT);

			OUT.pos = UnityObjectToClipPos(
				centreTop + 
				float3(cos60, 0, sin60) * .5 * _GrassWidth);
			OUT.uv = float2(1,1);
			triStream.Append(OUT);

			triStream.RestartStrip();
		}

		float4 frag(g2f IN) : COLOR {
			fixed4 c = tex2D(_MainTex, IN.uv) * _Color; 
			clip(c.a - _Cutoff); 
			return c;
		}

		ENDCG

		}
	}
}