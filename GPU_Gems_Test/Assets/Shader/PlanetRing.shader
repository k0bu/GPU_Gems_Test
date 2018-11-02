﻿Shader "Custom/PlanetRing" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_MinRenderDst ("Minimum Render Distance", Float ) = 10
		_MaxFadeDst ("Maximum Fading Distance", Float) = 20
	}
	SubShader {
		Tags { 
			"RenderType"="Transparent" 
			"IgnoreProjector"="True"
			"Queue"="Transparent"
		}
		LOD 200
		CULL OFF

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _MinRenderDst;
		float _MaxFadeDst;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float distance = length(_WorldSpaceCameraPos - IN.worldPos);
			fixed opacity = clamp((distance - _MinRenderDst) / (_MaxFadeDst - _MinRenderDst),0,1);
			o.Albedo = _Color;
			o.Metallic = _Metallic * opacity;
			o.Smoothness = _Glossiness * opacity;
			o.Alpha = opacity;
		}
		ENDCG
	}
	FallBack "Diffuse"
}