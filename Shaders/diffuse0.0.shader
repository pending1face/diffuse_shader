// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/diffuse0.0"
{
    Properties
    {
        _Diffuse("Diffuse Color", Color) = (1,1,1,1)
        rho("rho", Float) = 0.25
    }
        SubShader
    {
        Pass{
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            fixed4 _Diffuse;
            float rho;
        #include "Lighting.cginc"
        #include "UnityCG.cginc"
        #include "AutoLight.cginc"

        #pragma vertex vert
        #pragma fragment frag

            struct a2v {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f {
                float4 position:SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v v) {
                v2f f;
                //UNITY_MATRIX_MVP把模型空间映射到剪裁空间
                f.position = UnityObjectToClipPos(v.vertex);

                //把模型空间映射到世界坐标
                float3 pos = (float3) mul(unity_ObjectToWorld, v.vertex);
                //光的方向
                fixed3 lightDir;

                if (0.0 == _WorldSpaceLightPos0.w) // directional light?
                {
                    lightDir = _WorldSpaceLightPos0.xyz;
                }
                else // point or spot light
                {
                    lightDir = _WorldSpaceLightPos0.xyz - pos;

                }
                //     Debug.Log(_WorldSpaceLightPos0.xyz)

                     float3 l = normalize(lightDir);

                     //mul(v.normal,_World2Object);从模型空间到世界空间
                     float3 n = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                     float nl = max(0.0, dot(n, l));
                    
                     fixed3 diffuse = _LightColor0 * nl;
                         f.color = diffuse * _Diffuse.rgb;
                         //  f.color = _LightColor0.rgb *max(dot( normalize(lightDir) , n),0) * _Diffuse.rgb;
                           return f;
                       }

                       fixed4 frag(v2f f) :SV_Target{
                           return fixed4(f.color, 1);
                       }
                   ENDCG
                   }

    }
        FallBack "Diffuse"
}
