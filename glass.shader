// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Gloss("Gloss",Range(5,100))=10
		_LightColor0("LightColor0",Color)=(1,1,1,1)

		_ReflectColor("ReflectColor",Color)=(1,1,1,1)
		_ReflectAmount("ReflectAmount",Range(0,1))=0.05
		_Cubemap("reflection cubemap",Cube)="_Skybox"{}
	}
	SubShader
	{
		Tags {"Queue" = "Transparent"  }//��Ⱦ���� ��Ⱦ����
		LOD 200
		
		GrabPass{"_ScreenTex"}
		
		Pass
		{
			//ZWrite Off
			Cull Off//˫����Ⱦ

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			fixed	_Gloss;
			fixed _ReflectAmount;
			samplerCUBE _Cubemap ;
			fixed4 _ReflectColor:COLOR;
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				
				float3 worldPos : TEXCOORD2;
				float3 reftDir : TEXCOORD3;
				float3 viewDir : TEXCOORD4;
				float3 normal : TEXCOORD5;

				float4 vertex : SV_POSITION;
				float4 specular :COLOR0;


				SHADOW_COORDS(3)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;//xy_tilling+zw_offset
			sampler2D _ScreenTex;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);//�ü��ռ�����
				o.uv2 = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = ComputeGrabScreenPos(o.vertex);//��Ļ�ռ�����

				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 lightDir = normalize(UnityWorldSpaceLightDir(o.worldPos));
				o.normal=UnityObjectToWorldNormal(v.normal);
				o.reftDir=normalize(reflect(-lightDir,o.normal));
				o.viewDir=normalize(UnityWorldSpaceViewDir(o.worldPos));
				TRANSFER_SHADOW(o);

				fixed3 halfDir=normalize(lightDir+o.viewDir);

				fixed4 specular = _LightColor0 * pow(max(dot(halfDir,o.normal),0 ),_Gloss );
				o.specular=specular;

				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//fixed3 normal=normalize(i.normal);
				//fixed3 lightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				//fixed3 viewDir=normalize(i.viewDir);

				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;//�õ����������ɫ��ǿ����Ϣ

				fixed3 reflection=texCUBE(_Cubemap,normalize(i.reftDir)).rgb * _ReflectColor.rgb;
				//fixed3 reflection=(1,1,1);

				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

				// sample the texture
				i.uv.xy += float2(0.05,0.05);//ƫ��tilling
				fixed4 fra = tex2D(_ScreenTex, i.uv.xy/i.uv.w);
				fixed4 fle = tex2D(_MainTex, i.uv2);
				// apply fog
				fixed4 colorzheshe=lerp(fra, fle, 0.1);

				fixed4 COLORfinal=fixed4(ambient,0)*_ReflectAmount+(colorzheshe+fixed4(reflection,1)*_ReflectAmount)*atten;
				
				return COLORfinal+i.specular;
				//static function Lerp (from : Vector4, to : Vector4, t : float) : Vector4
				//��������֮������β�ֵ����������t��from��to֮���ֵ��t�Ǽ���[0...1]֮���ֵ������t = 0ʱ������from����t = 1ʱ������to����t = 0.5 ����from��to��ƽ������


			}
			//GUIUtility.ExitGUI()
			ENDCG
		}
	}
	//FallBack "Transparent/Cutout/VertexLit"
}

