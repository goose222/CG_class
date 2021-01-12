using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawControlLine : MonoBehaviour
{
    public GameObject dot1;
    public GameObject dot2;

    private LineRenderer line;


    // Start is called before the first frame update
    void Start()
    {
        line = gameObject.AddComponent<LineRenderer>();
       
    }

    // Update is called once per frame
    void Update()
    {
        DrawLines();
    }

    private void DrawLines() {
        int dotnum=2;

        line.positionCount=dotnum;
        //line.material = new Material(Shader.Find("Standard"));
        line.startColor = new Color(0f, 0f, 1f, 0.5f);
        line.endColor = new Color(0f, 0f, 1f, 0.5f);
        line.SetWidth(0.05f, 0.05f);

        //设置指示线的起点和终点
        line.SetPosition(0, dot1.transform.position);
        line.SetPosition(1, dot2.transform.position);


    }
        
        

}

