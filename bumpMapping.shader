// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/bumpMapping"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("normal map",2D)="bump"{}
       //_LightColor0("light color",Color)=(1,1,1,1)
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        pass{
            CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;
        sampler2D _NormalMap;
        float4 _NormalMap_ST;

        struct a2v{
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float4 tangent:TANGENT;
            float4 texcoord:TEXCOORD0;
        };
        struct v2f{
            float4 svPos:SV_POSITION;
            //float3 worldNormal:TEXCOORD0;
            float4 worldVertex:TEXCOORD1;
            float4 uv:TEXCOORD2;//1为tex；2为normalmap
            float4 uv2:TEXCOORD3;
            float3 lightDir:TEXCOORD4;
        };

        v2f vert(a2v v){
            v2f f;
            f.svPos=UnityObjectToClipPos(v.vertex);
            f.worldVertex=mul(v.vertex,unity_WorldToObject);
            f.uv.xy=v.texcoord.xy*_MainTex_ST.xy;
            f.uv.zw=_MainTex_ST.zw;
            f.uv2.xy=v.texcoord.xy*_NormalMap_ST.xy;
            f.uv2.zw=_NormalMap_ST.zw;

            TANGENT_SPACE_ROTATION;//rotation把切线空间转换到模型空间
            
            f.lightDir=mul(rotation,ObjSpaceLightDir(v.vertex));//模型空间下的平行光
            
            return f;
        }
        //法线相关计算放进切线空间
        fixed4 frag (v2f f):SV_Target
        {
            fixed4 normalColor=tex2D(_NormalMap,f.uv2);
            fixed3 tangentNormal=normalize(UnpackNormal(normalColor));

            fixed3 lightDir=normalize(f.lightDir);

            fixed3 texColor=tex2D(_MainTex,f.uv);
            fixed3 diffuse=_Color.rgb*texColor*(dot(tangentNormal,lightDir)+1);
            fixed3 tempColor= diffuse+UNITY_LIGHTMODEL_AMBIENT.rgb*texColor;
            return fixed4(tempColor,1);
        }
        ENDCG
        }
    }
    //FallBack "Specular"
}
