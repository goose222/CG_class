using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class drawBezier : MonoBehaviour
{
    private LineRenderer lineRenderer;
    public GameObject p0;
    public GameObject p1;
    public GameObject p2;
    public GameObject p3;

    private Vector3 result;
    private List<Vector3> resultList; 
    public int ratio = 1000;
    private float timeLerp=0;

    //private float maxTime = 0.5f;

    // Start is called before the first frame update
    void Start()
    {
        lineRenderer = gameObject.GetComponent<LineRenderer>();
        lineRenderer.startColor = new Color(0f, 0f, 0f, 0.7f);
        lineRenderer.endColor = new Color(0f, 0f, 0f, 0.7f);
        lineRenderer.startWidth = 0.1f;
        lineRenderer.endWidth = 0.1f;

    }
    /// <summary>
    /// ///////////
    /// </summary>
   // void FixedUpdate(){     }
    void CalculatePosition()
    {
        result = new Vector3();
        resultList = new List<Vector3>();

        for (timeLerp=0; timeLerp<=1f;timeLerp+=1f/ratio) {
            result.x = Mathf.Pow(1 - timeLerp, 3) * p0.transform.position.x + 3 * timeLerp * Mathf.Pow(1 - timeLerp, 2) * p1.transform.position.x
                    + 3 * (1 - timeLerp) * Mathf.Pow(timeLerp, 2) * p2.transform.position.x + Mathf.Pow(timeLerp, 3) * p3.transform.position.x;

            result.y = Mathf.Pow(1 - timeLerp, 3) * p0.transform.position.y + 3 * timeLerp * Mathf.Pow(1 - timeLerp, 2) * p1.transform.position.y
                     + 3 * (1 - timeLerp) * Mathf.Pow(timeLerp, 2) * p2.transform.position.y + Mathf.Pow(timeLerp, 3) * p3.transform.position.y;

            result.z = Mathf.Pow(1 - timeLerp, 3) * p0.transform.position.z + 3 * timeLerp * Mathf.Pow(1 - timeLerp, 2) * p1.transform.position.z
                     + 3 * (1 - timeLerp) * Mathf.Pow(timeLerp, 2) * p2.transform.position.z + Mathf.Pow(timeLerp, 3) * p3.transform.position.z;

            resultList.Add(result);
        }

        lineRenderer.positionCount = resultList.ToArray().Length;
        if (lineRenderer.positionCount >= 2)
        {
            lineRenderer.SetPositions(resultList.ToArray());
        }
    }


    // Update is called once per frame
    void Update()
    {
        CalculatePosition();    
    }
}
