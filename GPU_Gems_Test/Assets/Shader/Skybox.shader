Shader "Custom/Skybox" {
	Properties {
		_SunColor("Color", Color) = (1.0, 0.8, 0.5, 1)
		_SunDir("Sun Direction", Vector) = (0, 0.6, 1, 0)
		_SunStrength("Sun Strength", Range(0, 1)) = .2
	}
	SubShader {
		Tags {
			"RenderType" = "Background"
			"Queue" = "Background"
			"PreviewType" = "SkyBox"	
		}
		LOD 100

		Pass {
			ZWrite Off
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//#include "UnityCG.cginc"

			fixed3 _SunColor; 
			float3 _SunDir; 
			float _SunStrength; 

			struct appdata {
				float4 vertex:POSITION; 
				float3 lookDir:TEXCOORD0; 
			}; 

			struct v2f {
				float4 vertex:SV_POSITION; 
				float3 lookDir:TEXCOORD0; 
			}; 

			//sampler2D _MainTex; 
			//float4 _MainTex_ST; 
			
			v2f vert (appdata v) {
				v2f o; 
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.lookDir = v.lookDir; //TRANSFORM_TEX(v.lookDir, _MainTex); 
				return o; 
			}

			// float3 ConvertToPolarXZ (float3 sunDir){
			// 	const half radToNone = 1 / (3.1415926535 * 2);
			// 	half r = 1 - sqrt(sunDir.x * sunDir.x + sunDir.z * sunDir.z);
            //     half theta = atan2(sunDir.z, sunDir.x ) * radToNone;
			// 	sunDir.z = r;
			// 	sunDir.x = theta;

			// 	return sunDir;
			// }
			
			fixed4 frag (v2f i):SV_Target {
				// sample the texture
				fixed4 col = fixed4(lerp(fixed3(.5, 0, 0), fixed3(0, 0, .5), i.lookDir.y * 0.5 + 0.5), 1.0); 
				float3 dir = normalize(_SunDir);
				//float3 sunDir = ConvertToPolarXZ(dir);
				//float3 lookDir = ConvertToPolarXZ(i.lookDir);

				float angle = dot(_SunDir, i.lookDir);
				col += fixed4(_SunColor * pow(max(0.0, angle),  1.0 / _SunStrength), 0.0);
				//angle = dot(_SunDir, i.lookDir);
				//col += fixed4(_SunColor * pow(max(0.0, angle),  1.0 / _SunStrength), 0.0);
				//col += fixed4(_SunColor * pow((min(0.25, abs(sunDir.x-lookDir.x))-0.25)*(-1),  1/_SunStrength), 0.0);
				//angle = dot(sunDir + fixed3(0.3,0,0) , i.lookDir);
				
				//tex2D(_MainTex, i.lookDir); 
				

				return col; 
			}

			ENDCG
		}
	}
}
