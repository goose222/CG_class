using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class score : MonoBehaviour
{
    public AudioSource audio;
    public GameObject ballPrefabs;
    private void OnTriggerEnter(Collider ball)
    {
        if (ball.name == "ball" )
        {
            Destroy(ball.gameObject, 1f);
            Invoke("createBall",5);
            EventCenter.Broadcast(EventDefine.getPoint);
            audio.Play();
        }
    }
    private void createBall()
    {
        Vector3 ballWorldPos = new Vector3(Random.Range(-5, -2), 3, Random.Range(32, 33));
        GameObject.Instantiate(ballPrefabs, ballWorldPos, ballPrefabs.transform.rotation);
    }

}